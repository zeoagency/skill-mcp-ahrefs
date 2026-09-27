# Workflow: Commercial Intent Hijack & Alternative Pages

## 1. Executive Objective
Capture high-converting bottom-of-funnel (BoFu) search demand by identifying competitor comparison keywords ("competitor vs us", "competitor alternatives", "competitor pricing") and designing high-converting product comparison assets.

---

## 2. Tool Execution Chain

```
[Step 1: Competitor Page Identification] ──► ahrefs_top_pages(competitor, sort: "trafficValueUsd")
                 │
                 ▼ Filter for /vs/, /compare/, /alternatives/
[Step 2: Content Gap Extraction] ──► ahrefs_content_gap(target, competitors, country: "us", limit: 300)
                 │
                 ▼
[Step 3: Intent & Pattern Filtering] ──► ahrefs_query_artifact(
                   filters: [
                     { field: "intent", operator: "eq", value: "commercial" },
                     { field: "volume", operator: "gte", value: 300 }
                   ]
                 )
                 │
                 ▼
[Step 4: Search Intent Deep-Dive] ──► ahrefs_keyword_overview(keyword: "top alternative")
```

---

## 3. High-Converting Page Archetypes

1. **The Direct Comparison Matrix (`/vs/competitor`)**:
   - Focus: Transparent, feature-by-feature evaluation addressing BoFu buyers in the evaluation phase.
   - Target Keywords: `"[competitor] vs [target]"`, `"[competitor] alternative"`.
2. **The "Best Category Tools" Round-Up (`/best-crm-software`)**:
   - Focus: Multi-product buyer's guide ranking the target alongside top rivals.
   - High Traffic Value: Typically drives commercial CPCs exceeding $10–$25/click.
3. **The Pricing Transparency Page (`/pricing` / `/[competitor]-pricing`)**:
   - Focus: Answering specific pricing queries and total cost of ownership (TCO) comparisons.
