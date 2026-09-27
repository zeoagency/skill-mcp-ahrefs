# Workflow: Digital PR & Link Intersect Prospecting

## 1. Objective & Hypothesis
Identify referring domains that link to multiple key competitors but currently have zero links pointing to the target domain. These domains have an established editorial affinity for your niche.

---

## 2. Execution Pipeline

### Step 1: Execute Link Intersect
Call `ahrefs_link_intersect`:
```json
{
  "target": "mybrand.com",
  "competitors": ["rival1.com", "rival2.com", "rival3.com"],
  "limit": 100
}
```

### Step 2: Query High-Authority Prospects Locally
Call `ahrefs_query_artifact` on the resulting export ID:
```json
{
  "id": "exp_<uuid>",
  "select": ["domain", "domainRating", "intersectCount"],
  "filters": [
    { "field": "domainRating", "operator": "gte", "value": 45 },
    { "field": "intersectCount", "operator": "gte", "value": 2 }
  ],
  "sort": { "field": "domainRating", "direction": "desc" },
  "limit": 20
}
```

### Step 3: Batch Verify Prospect Footprints
Inspect top prospect domains using `ahrefs_site_overview_batch`:
```json
{
  "requests": [
    { "domain": "prospect1.com" },
    { "domain": "prospect2.com" },
    { "domain": "prospect3.com" }
  ]
}
```
Verify whether candidate domains have real organic search visibility (active publisher vs dead directory).

---

## 3. Outreach Angle Categorization
Categorize prospect domains into:
1. **Industry Review & Comparison Hubs**: Pitch product feature inclusion or pricing updates.
2. **Resource & Tool Guides**: Offer free calculators or proprietary benchmark reports.
3. **Thought Leadership / Editorial Guest Columns**: Identify contributing editor guidelines.
