# Lossless Canonical Storage vs Projections

## 1. The Artifact Architecture

The Ahrefs MCP server persists query results in a memory-backed artifact repository (`ReportStore`). Every analytical data query automatically generates a reusable artifact registered under a unique identifier:

- **Benchmark Reports (`run_<uuid>`)**: Composite audit results storing domain matrices, leaders, and sub-reports.
- **Tabular Exports (`exp_<uuid>`)**: Result tables from `organic_keywords`, `top_pages`, `backlinks`, `content_gap`, and `link_intersect`.

---

## 2. Canonical Data vs Flat Projections

Understanding the difference between the canonical dataset and its export projections is essential for lossless analysis:

```
[Upstream Ahrefs Extraction]
             │
             ▼
┌────────────────────────────────────────┐
│ Lossless Canonical Data (Stored in Mem)│  <─── Queried by: ahrefs_query_artifact
│ - Full typed objects & nested arrays   │       (zero spend, full fidelity)
│ - Exact numbers, dates, intent flags   │
└────────────────────────────────────────┘
             │
     ┌───────┴───────┐
     ▼               ▼
┌──────────────┐ ┌──────────────┐
│ CSV Export   │ │ Markdown     │  <─── Read by: ahrefs_read_artifact
│ (exp_*.csv)  │ │ Summary      │
└──────────────┘ └──────────────┘
(Flat projection (Visual preview)
```

### The Three Representations

| Dimension | Canonical Data (`canonicalData`) | CSV Export Projection (`.csv`) | Markdown Summary (`.md`) |
|:---|:---|:---|:---|
| **Storage Layer** | In-memory JavaScript object graph | Flattened RFC-4180 CSV text string | Rendered Markdown string |
| **Data Fidelity** | **100% Lossless**: preserves arrays, nested objects, raw types. | **Lossy**: arrays flattened (e.g., comma-separated), nested objects serialized. | **Truncated**: limited to top preview rows. |
| **Unmeasured Metrics** | Expressed as `undefined` (key omitted). | Expressed as empty CSV cell (`""`). | Rendered as em-dash (`—`). |
| **Primary Tool Interface** | `ahrefs_query_artifact` | `ahrefs_read_artifact(kind: "export")` | `ahrefs_read_artifact(kind: "report")` |
| **Economic Cost** | Zero API Spend | Zero API Spend | Zero API Spend |

---

## 3. Querying Advantages of Canonical Storage

When analyzing large datasets (e.g., 500 captured organic keywords):
1. **Never read raw CSV into LLM context**: A 500-row CSV consumes 15,000+ tokens.
2. **Execute typed queries against canonical storage**:
   - Call `ahrefs_query_artifact` to apply compound filters (e.g., `volume > 1000` AND `position <= 10`).
   - Use `select: ["keyword", "volume", "position"]` to retrieve only the 3 relevant columns.
   - Result: 90% reduction in context window token consumption while retaining 100% numerical fidelity.

---

## 4. Retention & Lifecycle Bounds

- **Storage Medium**: Volatile server memory.
- **TTL**: Artifacts expire after 24 hours.
- **Capacity**: Clamped at a maximum of 200 concurrent artifacts (FIFO eviction).
- **Restart Loss**: Server redeployments or container restarts flush memory storage.
- **Credential Scope**: Artifacts are scoped to the connection token. An unknown artifact ID returns `artifact_not_found` and requires re-running the producing tool.
