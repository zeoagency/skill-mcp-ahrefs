# Scenario: Striking-Distance Local Qualification

## Context & Scenario Brief
An executive requests: *"Find our best near-term SEO opportunities to increase organic pipeline without building net-new pages."*
The agent identifies this as a **Striking Distance Investigation** (positions 4–15).

---

## Step 1: Upstream Acquisition

The agent initiates an organic keyword capture sorted by position to acquire candidates on the cusp of Page 1:

```json
// Tool: ahrefs_organic_keywords
{
  "domain": "acme-saas.com",
  "country": "us",
  "limit": 200,
  "sort": "position",
  "sortDirection": "asc"
}
```

**Returned Metadata**:
- `capturedRowCount`: 200
- `returnedRowCount`: 200
- `exportUri`: `ahrefs://exports/exp_a81f39bc-4b92-4112-9213-90d182e1c94b.csv`
- `artifactId`: `exp_a81f39bc-4b92-4112-9213-90d182e1c94b`

---

## Step 2: Zero-Spend In-Memory Qualification

Rather than re-calling Ahrefs or pulling 200 rows of CSV into LLM context, the agent uses `ahrefs_query_artifact` to isolate high-value opportunities:

```json
// Tool: ahrefs_query_artifact
{
  "id": "exp_a81f39bc-4b92-4112-9213-90d182e1c94b",
  "select": ["keyword", "position", "volume", "cpc", "keywordDifficulty", "url"],
  "filters": [
    { "field": "position", "operator": "gte", "value": 4 },
    { "field": "position", "operator": "lte", "value": 15 },
    { "field": "volume", "operator": "gte", "value": 500 }
  ],
  "sort": { "field": "volume", "direction": "desc" },
  "limit": 10
}
```

---

## Step 3: Result Analysis & Opportunity Scoring

The query returns 10 qualified rows from server memory in 8ms at zero API cost:

| Keyword | Position | Volume | CPC (\$) | KD | URL | SDOS |
|:---|---:|---:|---:|---:|:---|---:|
| `b2b payment gateway` | 6 | 4,800 | \$14.20 | 28 | `/solutions/payments` | **391.7** |
| `subscription billing api` | 8 | 2,400 | \$9.80 | 18 | `/docs/billing` | **154.7** |
| `recurring invoice software` | 5 | 1,900 | \$8.50 | 22 | `/products/invoicing` | **140.4** |

---

## Step 4: Donor Page Identification & Handoff

The agent calls `ahrefs_top_pages(domain: "acme-saas.com", limit: 10)` to discover internal linking donors:
- Donor URL: `/blog/saas-metrics-guide` (Traffic: 18,500/mo) -> Links to `/solutions/payments` with anchor `"B2B payment gateway"`.

**Conclusion**: Actionable, high-impact sprint recommendation generated with only 2 paid calls and 1 free artifact query.
