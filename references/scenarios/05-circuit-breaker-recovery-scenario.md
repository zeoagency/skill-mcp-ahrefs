# Scenario: Batch Circuit-Breaker Tripping & Selective Recovery

## Context & Scenario Brief
The agent is auditing a competitive set of 4 domains using `ahrefs_site_overview_batch`. During execution, the server's upstream session expires.

---

## Step 1: Invocations & Circuit Breaker Trip

```json
// Tool: ahrefs_site_overview_batch
{
  "requests": [
    { "requestId": "req-1", "domain": "site1.com" },
    { "requestId": "req-2", "domain": "site2.com" },
    { "requestId": "req-3", "domain": "site3.com" },
    { "requestId": "req-4", "domain": "site4.com" }
  ]
}
```

**Returned Batch Payload**:
- `totalRequests`: 4
- `succeededCount`: 1
- `failedCount`: 3
- `results`:
  - `req-1` (`site1.com`): `status: "ok"`, data captured successfully.
  - `req-2` (`site2.com`): `status: "failed"`, `code: "session_expired"`, `message: "Ahrefs session cookie expired"`.
  - `req-3` (`site3.com`): `status: "failed"`, `code: "auth_circuit_broken"`, `message: "Execution aborted due to shared authentication failure on preceding item"`.
  - `req-4` (`site4.com`): `status: "failed"`, `code: "auth_circuit_broken"`.

---

## Step 2: Autonomous Self-Healing Protocol

1. **Verify Circuit Trip**:
   - The agent observes `session_expired` on `req-2` and `auth_circuit_broken` on remaining items.
   - It respects the **1-retry authentication budget**.
2. **Execute Re-Authentication**:
   ```json
   // Tool: ahrefs_auth_login
   {
     "relogin": true
   }
   ```
   *Response*: `{"authenticated": true, "profileName": "Enterprise-Seat", "lastVerifiedAt": "2026-09-27T23:42:00Z"}`.

---

## Step 3: Selective Recovery (Zero Duplicate Spend)

- **Naive Agent Error**: Resubmits all 4 domains (`site1.com` through `site4.com`), re-spending credits on `site1.com`.
- **Intelligent Agent Action**: Omits `req-1` (which already succeeded) and resubmits ONLY the failed items:

```json
// Tool: ahrefs_site_overview_batch
{
  "requests": [
    { "requestId": "req-2", "domain": "site2.com" },
    { "requestId": "req-3", "domain": "site3.com" },
    { "requestId": "req-4", "domain": "site4.com" }
  ]
}
```

All 3 items complete with `status: "ok"`. The agent merges the datasets and delivers the complete 4-domain audit.

**Key Takeaway**: Selective recovery preserves successful batch items and avoids duplicate paid extractions.
