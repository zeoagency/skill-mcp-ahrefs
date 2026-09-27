# Tool Playbook: Keyword Intelligence & SERP Rankings

## 1. `ahrefs_keyword_overview`
- **Economic Classification**: PAID (1 paid Ahrefs query, ~10–25s latency).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Inspect one keyword in one country's Google database.
- **Parameters**:
  ```typescript
  {
    keyword: string;                  // Exact keyword phrase (min 1, max 200 chars)
    country?: string;                 // 2-letter ISO code. Defaults to 'us'.
    engine?: "google";                // Default: 'google'. Third-party engines are rejected.
  }
  ```
- **Nuances**:
  - Global search volume is a separate metric; Keywords Explorer operates on localized country databases.
  - KD and estimated referring domains are screening signals, not mathematical ranking guarantees.
- **Key Outputs**: `volume`, `difficulty` (KD 0–100), `trafficPotential`, `cpc`, `parentTopic`, `matchingTerms[]`, `questions[]`, `serpFeatures[]`.

---

## 2. `ahrefs_keyword_overview_batch`
- **Economic Classification**: PAID (1 paid query per distinct keyword).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Execute a batch of 1 to 20 Keywords Explorer overview queries in a single call.
- **Parameters**:
  ```typescript
  {
    requests: Array<{
      requestId?: string;             // Optional correlation ID (max 64 chars)
      keyword: string;                // Search term (required)
      country?: string;               // 2-letter ISO code (default: 'us')
      engine?: "google";              // Default: 'google'
    }>; // Min 1, max 20 objects
  }
  ```
- **Built-in Circuit Breaker & Deduplication**:
  - In-flight deduplication of case-insensitive keyword matches (`"seo tools"` vs `"SEO TOOLS"`).
  - Trips circuit breaker on auth failure (`auth_circuit_broken`).
- **Outputs**: `{ results: Array<{ requestId?, keyword, country, status: "ok" | "failed" | "auth_circuit_broken", data?, error? }>, totalRequests, deduplicatedCount, succeededCount, failedCount }`.

---

## 3. `ahrefs_organic_keywords`
- **Economic Classification**: PAID (1 paid query, ~15–40s latency). Emits CSV export artifact (`exportUri`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve a bounded, sorted capture of ranking keyword rows for one hostname and its subdomains.
- **Parameters**:
  ```typescript
  {
    domain: string;                   // Bare domain (required)
    country?: string;                 // Optional 2-letter ISO code. Omit for worldwide rankings.
    limit?: number;                   // 1 to 1000. Default: 100.
    sort?: "traffic" | "volume" | "position" | "cpc"; // Default: 'traffic'
    sortDirection?: "asc" | "desc";   // Default: 'desc'
    minVolume?: number;               // Post-capture volume filter
    maxKd?: number;                   // Post-capture difficulty filter (0–100)
    intent?: "informational" | "navigational" | "commercial" | "transactional";
  }
  ```
- **Post-Capture Filtering Provenance**:
  - Ahrefs fetches top $N$ rows (governed by `sort` and `limit`). `minVolume`, `maxKd`, and `intent` filter the **captured slice in memory**.
  - Always inspect `retrievalMetadata`:
    ```typescript
    {
      capturedRowCount: number,
      returnedRowCount: number,
      filterStage: "post_capture",
      warnings?: string[]
    }
    ```
- **Key Outputs**: `keywords[]` array, `totalRows`, `retrievalMetadata`, `exportUri` (`ahrefs://exports/exp_...`).
