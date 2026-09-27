# Batch Operations & Circuit-Breaker Architecture

## 1. Overview of Homogeneous Batch Tools

The Ahrefs MCP server provides two dedicated, homogeneous batch operations designed to consolidate multiple lookups into a single network turn:

1. `ahrefs_site_overview_batch`: Evaluates 1 to 10 hostnames in one turn.
2. `ahrefs_keyword_overview_batch`: Evaluates 1 to 20 search keywords in a single country database in one turn.

These tools eliminate repetitive single-item tool round trips, centralize error handling, and protect upstream accounts against runaway rate limits.

---

## 2. Shared-Profile Serialization Invariant

### The Architectural Reality
- Batching does **not** perform parallel headless browser extraction upstream.
- Behind the scenes, the server's shared browser coordinator drives Ahrefs pages sequentially to prevent IP bans, account concurrency collisions, and bot challenges.
- **Agent Policy**: Do not assume batching cuts raw upstream extraction duration to zero. A batch of 10 domains will still take sequential browser time (~15–30 seconds per domain). The primary advantage is reducing LLM conversational round trips, token latency, and unifying correlation.

---

## 3. Input Contracts & Correlation IDs

Both batch tools require a structured `requests` array where each item can carry an optional client-provided `requestId`:

```typescript
// ahrefs_site_overview_batch
{
  "requests": [
    { "requestId": "target-row", "domain": "mysite.com", "country": "us", "mode": "subdomains" },
    { "requestId": "rival-1", "domain": "competitor1.com", "country": "us", "mode": "subdomains" },
    { "requestId": "rival-2", "domain": "competitor2.com", "country": "us", "mode": "subdomains" }
  ]
}

// ahrefs_keyword_overview_batch
{
  "requests": [
    { "requestId": "kw-crm", "keyword": "crm software", "country": "us" },
    { "requestId": "kw-erp", "keyword": "cloud erp", "country": "us" }
  ]
}
```

### In-Flight Deduplication
- If identical requests (same domain/country/mode or same keyword/country) appear multiple times within the `requests` array:
  - The server extracts the data point **exactly once**.
  - All matching input items share the single extracted result mapped by their respective `requestId`.
  - The output reports `deduplicatedCount`.

---

## 4. Upstream Circuit Breakers (`auth_circuit_broken`)

To protect upstream account quotas and prevent wasting credits during outages, batch tools feature an automated **Session & Rate-Limit Circuit Breaker**:

```
Item 1: Executing ──► 401 Session Expired ──► [TRIP CIRCUIT BREAKER]
Item 2: Cancelled (Status: "failed", Code: "auth_circuit_broken")
Item 3: Cancelled (Status: "failed", Code: "auth_circuit_broken")
```

### Trigger Conditions
The circuit breaker trips immediately if any item encounters:
1. `session_expired` / 401 Unauthorized.
2. `rate_limit_exceeded` / Upstream 429.
3. Persistent bot challenge / Cloudflare block.

### Result Schema & Triage
- Items executed before the trip preserve their results (`status: "ok"`).
- Remaining queued items fail fast with:
  ```json
  {
    "requestId": "kw-erp",
    "status": "failed",
    "error": {
      "code": "auth_circuit_broken",
      "message": "Execution aborted due to shared authentication failure on preceding item.",
      "retryable": true
    }
  }
  ```
- **Agent Policy**: When `auth_circuit_broken` is observed, initiate auth recovery via `ahrefs_auth_login(relogin: true)`. After successful re-authentication, retry ONLY the failed items, never the entire original batch.
