# Workflow: Brand vs Non-Brand Traffic Disentanglement

## 1. Executive Objective
Disentangle branded search volume (navigational queries containing the brand or product name) from generic category search demand (non-brand queries) to evaluate true organic acquisition health and vulnerability to competitors.

---

## 2. Tool Execution Chain

```
[Step 1: Capture Ranking Footprint] ──► ahrefs_organic_keywords(domain: target, limit: 500, sort: "traffic")
                 │
                 ▼
[Step 2: Brand Query Segmentation] ──► ahrefs_query_artifact(
                   filters: [
                     { field: "keyword", operator: "contains", value: "brandname" }
                   ]
                 )
                 │
                 ▼
[Step 3: Non-Brand Opportunity Pool] ──► ahrefs_query_artifact(
                   filters: [
                     { field: "keyword", operator: "neq", value: "brandname" }
                   ],
                   sort: { field: "volume", direction: "desc" }
                 )
```

---

## 3. Diagnostic Health Matrix

| Metric | Healthy Organic Profile | Brand-Dependent Profile | Stagnant Authority Profile |
|:---|:---:|:---:|:---:|
| **Brand Traffic Share** | $25\% - 45\%$ | $>75\%$ | $<15\%$ |
| **Non-Brand Traffic Share**| $55\% - 75\%$ | $<25\%$ | $>85\%$ (low overall volume) |
| **Non-Brand Traffic Value**| High (diversified commercial terms) | Low (brand clicks drive false volume) | Low (thin ranking depth) |
| **Strategic Diagnosis** | Strong organic engine acquiring net-new buyers. | Vulnerable to category disruption; zero organic moat outside existing brand equity. | High generic reach but poor brand awareness and low user retention. |

---

## 4. Strategic Remediation for Brand-Heavy Sites
1. **Category Pillar Creation**: Construct authoritative top-of-funnel and mid-funnel hubs targeting non-branded category queries.
2. **Striking Distance Push**: Identify non-brand keywords currently in positions 4–15 using `ahrefs_query_artifact` and execute on-page re-optimization.
3. **Internal Equity Distribution**: Use high-traffic brand landing pages (homepage, login) to distribute PageRank via footer or navigation links to commercial non-brand pillars.
