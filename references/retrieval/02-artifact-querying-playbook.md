# In-Memory Artifact Querying Playbook

## 1. Overview & Strategy

When tools emit an `exportUri` (`ahrefs://exports/exp_<uuid>.csv`) or `reportUri` (`ahrefs://reports/run_<uuid>`), the underlying records are preserved in server memory (`reportStore`) as structured canonical rows.

Instead of re-running paid Ahrefs extractions or pulling hundreds of rows into LLM context, use `ahrefs_query_artifact` to slice, project, and sort data in memory at zero cost.

---

## 2. Parameter Syntax & Rules

### A. Field Projection (`select`)
Project only the fields required for the analysis. For example, instead of loading 15 columns:
```json
{
  "id": "exp_4b9a12c8-3d12-4a5e-b91c-7f8a9e012345",
  "select": ["keyword", "position", "volume", "url", "traffic"]
}
```

### B. Compound Filtering (`filters`)
Filters are evaluated conjunctively (`AND`). Operators: `eq`, `neq`, `gt`, `gte`, `lt`, `lte`, `contains`, `in`.

Example: Finding Striking Distance Opportunities (Positions 4–15 with volume $\ge 500$):
```json
{
  "id": "exp_4b9a12c8-3d12-4a5e-b91c-7f8a9e012345",
  "select": ["keyword", "position", "volume", "url", "traffic"],
  "filters": [
    { "field": "position", "operator": "gte", "value": 4 },
    { "field": "position", "operator": "lte", "value": 15 },
    { "field": "volume", "operator": "gte", "value": 500 }
  ],
  "sort": { "field": "traffic", "direction": "desc" },
  "limit": 25
}
```

Example: Filtering Backlinks for High-Authority Dofollow Links:
```json
{
  "id": "exp_8c2e11d0-1b44-4f2a-89a1-5d9c7e112233",
  "select": ["referringPageUrl", "anchorText", "domainRating", "followType"],
  "filters": [
    { "field": "domainRating", "operator": "gte", "value": 50 },
    { "field": "followType", "operator": "eq", "value": "dofollow" }
  ],
  "sort": { "field": "domainRating", "direction": "desc" },
  "limit": 50
}
```

---

## 3. Paging State & Field Discovery

- If you don't know the exact canonical field names, make a small discovery call:
  ```json
  { "id": "exp_...", "limit": 1 }
  ```
- Inspect `fields` in the response, then apply `select` and `filters` using verified field names.
- Use `totalMatchedRows` to report the total qualifying population without loading all rows.
