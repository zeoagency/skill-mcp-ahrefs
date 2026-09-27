# Workflow: Content Decay & Traffic Recovery Audit

## 1. Objective & Hypothesis
Detect legacy high-performing URLs that have suffered keyword ranking erosion over the past 3 to 12 months, and formulate an evidence-based revitalization plan.

---

## 2. Execution Pipeline

### Step 1: Capture Top Page Inventory
Call `ahrefs_top_pages`:
```json
{
  "domain": "targetsite.com",
  "sort": "traffic",
  "sortDirection": "desc",
  "limit": 100
}
```

### Step 2: Query Underperforming Commercial Pages
Call `ahrefs_query_artifact` to identify pages with substantial traffic value but slipping primary keyword positions:
```json
{
  "id": "exp_<uuid>",
  "select": ["url", "traffic", "trafficValueUsd", "topKeyword", "topKeywordPosition", "topKeywordVolume"],
  "filters": [
    { "field": "topKeywordPosition", "operator": "gte", "value": 7 }
  ],
  "sort": { "field": "trafficValueUsd", "direction": "desc" },
  "limit": 20
}
```

### Step 3: Batch Verify Decaying Primary Terms
Inspect whether parent topics or SERP features have evolved using `ahrefs_keyword_overview_batch`:
```json
{
  "requests": [
    { "keyword": "decaying_term_1", "country": "us" },
    { "keyword": "decaying_term_2", "country": "us" }
  ]
}
```

---

## 3. Revitalization Action Checklist
1. **Freshness Refresh**: Update outdated statistics, dates, screenshots, and broken external links.
2. **Semantic Expansion**: Cover newly emerging sub-topics discovered in `matchingTerms[]`.
3. **Internal PageRank Inflow**: Route 2–3 contextual links from newly published high-performing URLs to the decaying URL.
4. **Structured Data Update**: Refresh `dateModified` in Article/BlogPosting schema markup.
