# Retrieval Provenance & Post-Capture Filtering

## 1. Post-Capture Filtering Architecture

Tabular extraction tools (`ahrefs_organic_keywords`, `ahrefs_top_pages`, `ahrefs_content_gap`) retrieve a bounded population of records from Ahrefs determined by `limit` and `sort`, and then apply secondary filters (`minVolume`, `maxKd`, `minTraffic`, `intent`) in server memory.

### The Retrieval Metadata Block
Every tabular output includes:
```typescript
{
  retrievalMetadata: {
    capturedRowCount: number,    // Number of raw rows pulled from Ahrefs
    returnedRowCount: number,    // Number of rows surviving in-memory filters
    filterStage: "post_capture", // Explicit disclosure
    warnings?: string[]          // Diagnostic notices
  }
}
```

---

## 2. The "Empty Slice" Trap

When requesting strict filters on a small capture:
- If you call `ahrefs_organic_keywords(domain: "example.com", limit: 20, minVolume: 10000)`:
  - Upstream captures the top 20 keywords sorted by traffic.
  - If none of those 20 has volume $\ge 10,000$, `returnedRowCount` will be `0`.
  - **This does NOT mean the domain has zero keywords with volume $\ge 10,000$ in Ahrefs' entire database.** It only means none existed in the captured top 20 slice.

### Operational Rule
- When applying post-capture filters, set `limit` to a sufficiently large sample (e.g., `100` to `500`).
- If results are sparse or empty, inspect `capturedRowCount`. If `capturedRowCount > 0` but `returnedRowCount === 0`, broaden your filter thresholds or increase `limit`.
