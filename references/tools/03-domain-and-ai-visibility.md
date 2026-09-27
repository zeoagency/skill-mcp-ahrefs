# Tool Playbook: Domain Authority & AI Visibility

## 1. `ahrefs_site_overview`
- **Economic Classification**: PAID (1 paid Ahrefs query, ~15–35s latency).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve headline domain metrics: Domain Rating (DR), URL Rating (UR), estimated organic traffic and value, total backlinks, and referring domains.
- **Parameters**:
  ```typescript
  {
    domain: string;                          // Bare domain (e.g. 'stripe.com'). Strictly normalized.
    mode?: "subdomains" | "domain" | "exact"; // Default: 'subdomains'
    country?: string;                        // 2-letter ISO code (e.g. 'us'). Omit for worldwide totals.
  }
  ```
- **Nuances**:
  - `mode: "exact"` evaluates the root homepage URL, not an arbitrary deep path.
  - When `country` is omitted, organic traffic is worldwide while rank metrics reflect the strongest country.
  - Does NOT enumerate individual ranking keywords or backlink URLs.
- **Key Outputs**: `domainRating`, `urlRating`, `organicTraffic`, `organicTrafficChange`, `organicKeywords`, `referringDomains`, `totalBacklinks`, `paidTrafficCostUsd`, `aiResponsesTotal`.

---

## 2. `ahrefs_site_overview_batch`
- **Economic Classification**: PAID (1 paid query per distinct item).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Execute a batch of 1 to 10 Site Overview queries in a single MCP invocation.
- **Parameters**:
  ```typescript
  {
    requests: Array<{
      requestId?: string;                     // Optional correlation ID (max 64 chars)
      domain: string;                         // Bare domain (required)
      country?: string;                       // Optional 2-letter ISO code
      mode?: "subdomains" | "domain" | "exact"; // Default: 'subdomains'
    }>; // Min 1, max 10 objects
  }
  ```
- **Built-in Circuit Breaker & Deduplication**:
  - Automatically deduplicates identical `domain/country/mode` items within the batch.
  - If item $N$ encounters an authentication failure (`session_expired`), subsequent items in the batch are short-circuited with `auth_circuit_broken` to protect account credits.
- **Outputs**: `{ results: Array<{ requestId?, domain, country?, mode, status: "ok" | "failed" | "auth_circuit_broken", data?, error? }>, totalRequests, deduplicatedCount, succeededCount, failedCount }`.

---

## 3. `ahrefs_ai_visibility`
- **Economic Classification**: PAID (1 paid query, ~15–30s latency).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve observed citations of a domain in monitored Google AI Overviews and Brand Radar prompts.
- **Parameters**:
  ```typescript
  {
    domain: string; // Bare domain (required)
  }
  ```
- **Nuances**:
  - Returns aggregate citation counts, monitored brand prompts, platform share, and historical change.
  - Does NOT return the complete full-text of every cited webpage or capture unmonitored LLM chats.
- **Key Outputs**: `totalCitations`, `citedPagesCount`, `platformShare`, `sentimentBreakdown`, `topCitedQueries[]`.
