# Tool Playbook: Pages & Backlinks

## 1. `ahrefs_top_pages`
- **Economic Classification**: PAID (1 paid Ahrefs query, ~15–40s latency). Emits CSV export artifact (`exportUri`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve a bounded capture of organic-traffic pages for one hostname and its subdomains, with traffic estimates, traffic share, advertising-equivalent value, and top keyword metrics.
- **Parameters**:
  ```typescript
  {
    domain: string;                   // Bare domain (required)
    country?: string;                 // Optional 2-letter ISO code. Omit for worldwide totals.
    limit?: number;                   // 1 to 1000. Default: 100.
    sort?: "traffic" | "trafficValueUsd"; // Default: 'traffic'
    sortDirection?: "asc" | "desc";   // Default: 'desc'
    minVolume?: number;               // Post-capture volume filter for top keyword
    minTraffic?: number;              // Post-capture traffic filter for page
    maxKd?: number;                   // Post-capture difficulty filter for top keyword
    intent?: "informational" | "navigational" | "commercial" | "transactional";
  }
  ```
- **Nuances**:
  - Without country, page traffic is worldwide while each top keyword has its own specific location marker (`topKeywordCountry`).
  - Does NOT represent a complete site inventory (crawl) or historical traffic loss.
- **Key Outputs**: `pages[]` array (`url`, `traffic`, `trafficPercentage`, `trafficValueUsd`, `topKeyword`, `topKeywordVolume`, `topKeywordPosition`, `topKeywordCountry`), `retrievalMetadata`, `exportUri`.

---

## 2. `ahrefs_backlinks`
- **Economic Classification**: PAID (1 paid query, ~15–40s latency). Emits CSV export artifact (`exportUri`).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: true`.
- **Purpose**: Retrieve a bounded capture of inbound backlink records for one hostname and its subdomains.
- **Parameters**:
  ```typescript
  {
    domain: string;                   // Bare domain (required)
    limit?: number;                   // 1 to 1000. Default: 50.
    grouping?: "onePerDomain" | "all"; // Default: 'onePerDomain'
    sort?: "dr" | "traffic" | "firstSeen"; // Default: 'dr'
    sortDirection?: "asc" | "desc";   // Default: 'desc'
  }
  ```
- **Nuances**:
  - `firstSeen` is Ahrefs' discovery date, not necessarily when the link was published on the web.
  - Referring-page organic traffic is NOT referral traffic to the target; it is the source page's estimated Google search traffic.
- **Key Outputs**: `backlinks[]` array (`referringPageUrl`, `sourceTitle`, `targetUrl`, `anchorText`, `dr`, `ur`, `followType`, `firstSeen`), `exportUri`.
