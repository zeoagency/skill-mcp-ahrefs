# Workflow: International Market Expansion & Geo-Targeting

## 1. Executive Objective
Evaluate market entry feasibility, localized search demand, and competitive presence across multiple international search databases (e.g., US, UK, DE, FR, TR) to prioritize international expansion without speculative expenditure.

---

## 2. Tool Execution Chain

```
[Step 1: Multi-Country Baseline] ──► ahrefs_site_overview_batch (target in US, UK, DE, FR)
                 │
                 ▼
[Step 2: Localized Competitor Audit] ──► ahrefs_benchmark(country: "de", components: ["overview"])
                 │
                 ▼
[Step 3: Localized Content Gap] ──► ahrefs_content_gap(country: "de", limit: 200)
                 │
                 ▼
[Step 4: Zero-Spend Qualification] ──► ahrefs_query_artifact (filter by volume > 500, intent: "commercial")
                 │
                 ▼
[Step 5: Keyword Batch Qualification] ──► ahrefs_keyword_overview_batch(keywords: topGaps, country: "de")
```

---

## 3. Analytical Decisions & Architecture

1. **ccTLD vs Subdirectory Strategy**:
   - Inspect competitor domain structures: Are market leaders using dedicated ccTLDs (`competitor.de`) or language subdirectories (`competitor.com/de/`)?
   - Evaluate whether existing root domain authority (DR) carries into international subdirectories or whether local ccTLD competitors dominate local SERPs.
2. **Search Volume Localization**:
   - Never assume English search volume translates proportionally into foreign markets.
   - Use `ahrefs_keyword_overview_batch` with the target country code to capture true local demand and localized CPCs.
3. **Prioritization Framework**:
   - Rank target markets by **Addressable Market Value (AMV)**:
     $$\text{AMV} = \sum (\text{Local Category Volume} \times \text{Local CPC})$$
