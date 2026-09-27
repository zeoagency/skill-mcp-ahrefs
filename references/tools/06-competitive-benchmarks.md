# Tool Playbook: Competitive Matrices & Benchmarks

## 1. `ahrefs_content_gap`
- **Economic Classification**: PAID (1 paid Ahrefs query, ~20–45s latency). Emits CSV export artifact (`exportUri`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Compare a target hostname with supplied competitors in one country database and return a bounded keyword-opportunity capture.
- **Parameters**:
  ```typescript
  {
    target: string;                   // Target domain (required)
    competitors: string[];            // 1 to 10 competitor hostnames (required)
    country?: string;                 // 2-letter ISO code. Defaults to 'us'. No worldwide mode.
    limit?: number;                   // 1 to 1000. Default: 50.
    minVolume?: number;               // Post-capture volume filter
    maxKd?: number;                   // Post-capture difficulty filter
    intent?: "informational" | "navigational" | "commercial" | "transactional";
  }
  ```
- **Nuances**:
  - Country defaults to US; there is no worldwide Content Gap mode in Ahrefs.
  - Interpret numeric positions, reported non-ranking, and unavailable competitor attribution separately.
- **Key Outputs**: `gapKeywords[]` array (`keyword`, `volume`, `kd`, `competitorRankings`), `retrievalMetadata`, `exportUri`.

---

## 2. `ahrefs_link_intersect`
- **Economic Classification**: PAID (1 paid query, ~20–45s latency). Emits CSV export artifact (`exportUri`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve a bounded list of referring domains observed linking to supplied competitors but NOT to the target domain.
- **Parameters**:
  ```typescript
  {
    target: string;                   // Target domain (required)
    competitors: string[];            // 1 to 10 competitor hostnames (required)
    limit?: number;                   // 1 to 1000. Default: 50.
  }
  ```
- **Nuances**:
  - This is global link data: no country filter is supported.
  - Per-competitor `null`/`none` means observed non-presence under the contract; missing attribution is different.
- **Key Outputs**: `intersectDomains[]` array (`domain`, `domainRating`, `competitorIntersects`), `exportUri`.

---

## 3. `ahrefs_benchmark`
- **Economic Classification**: PAID (Composite multi-domain workload; 90-second deadline). Emits comprehensive report artifact (`runId`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Run an integrated comparison of a target and supplied competitors, including headline metrics and configured content-gap and link-intersect summaries.
- **Parameters**:
  ```typescript
  {
    target: string;                   // Target bare domain (required)
    competitors: string[];            // 1 to 20 competitor hostnames (required)
    country?: string;                 // Optional 2-letter ISO code.
    components?: Array<"overview" | "content_gap" | "link_intersect">; // Modular selection
  }
  ```
- **Modular Component Selection**:
  - Omission requests all three components (`["overview", "content_gap", "link_intersect"]`).
  - Pass `components: ["overview"]` when you only need domain metric matrices. This skips heavy scraping, cuts execution time by ~60%, and avoids 90s deadline timeouts.
- **Coverage Ledger & Leaders**:
  - `coverage.isComplete`: Check whether all domains finished.
  - Leaders and `logarithmicAuthorityMean` are computed strictly over **measured domains**.
  - A failed domain row remains visible with status `"failed"` and `—` cells. Never discard a partial benchmark.
- **Key Outputs**: `rows[]`, `leaders`, `logarithmicAuthorityMean`, `coverage`, `runId`, `reportUri`.
