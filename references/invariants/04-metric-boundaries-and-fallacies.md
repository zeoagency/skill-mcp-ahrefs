# Metric Boundaries & Analytical Fallacies

## 1. Metric Fallacy 1: Traffic Value is Not Cash Revenue

### The Mechanism
`trafficValueUsd` in `ahrefs_site_overview` and `ahrefs_top_pages` is calculated as:
$$\text{Traffic Value} = \sum_{i=1}^{N} \left( \text{Estimated Organic Traffic}_i \times \text{Google Ads CPC}_i \right)$$

### The Fallacy
Conflating Traffic Value with actual corporate revenue, Annual Recurring Revenue (ARR), Gross Merchandise Value (GMV), or profit.

### The Boundary & Truth Standard
- **What it represents**: The estimated monthly acquisition cost in Google Ads required to acquire the equivalent organic search volume through paid pay-per-click (PPC) advertising.
- **Reporting Protocol**:
  - Refer to it as *"Estimated PPC Replacement Value"* or *"Organic Traffic Equivalent Value"*.
  - Never state: "The website generated $45,000 in revenue from organic search."
  - Highlight it as an indicator of commercial monetization potential and paid acquisition cost savings (CAC mitigation).

---

## 2. Metric Fallacy 2: Domain Rating (DR) is Logarithmic, Not Linear

### The Mechanism
Domain Rating (DR) measures the quantity and quality of root referring domains linking to a target website on a logarithmic 0–100 scale:
- A website with DR 30 has roughly $10\times$ more link authority weight than DR 20.
- A website with DR 70 has roughly $100\times$ more authority weight than DR 50.

### The Fallacy
1. Taking the arithmetic mean of competitor DRs: $\frac{DR_1 + DR_2 + \dots + DR_N}{N}$ is mathematically invalid because DR is a logarithmic power-law metric.
2. Equating DR with Google's proprietary PageRank or assuming DR guarantees top rankings for high-KD keywords without content relevance.

### The Logarithmic (Decibel) DR Mean Formula
When aggregating authority across multiple domains (as in `ahrefs_benchmark`), use the decibel-scaled logarithmic mean:
$$\mu_{\text{dB}} = 10 \cdot \log_{10}\left( \frac{1}{N} \sum_{i=1}^{N} 10^{\frac{DR_i}{10}} \right)$$

### The Boundary & Truth Standard
- Always report DR alongside total Referring Domains (`refDomains`) and Dofollow ratios.
- Disclose that DR is an external Ahrefs link-graph proxy, not an official Google ranking factor.
- A high DR does not compensate for thin content, poor technical Core Web Vitals, or mismatched search intent.

---

## 3. Metric Fallacy 3: AI Citations are Monitored Samples, Not Total AI Usage

### The Mechanism
`ahrefs_ai_visibility` tracks brand and domain citations observed across Ahrefs' monitored corpus of queries in Google AI Overviews and Brand Radar prompts.

### The Fallacy
1. Assuming monitored citation counts equal total brand mentions across the entire web or all conversational LLMs.
2. Treating `citedPages` as a scraped list of URLs (it is an aggregate integer count of how many distinct URLs were cited).
3. Summing AI Overviews citations into all-platform totals (AI Overviews is already included in the aggregate total).

### The Boundary & Truth Standard
- Clarify that AI visibility metrics represent *observed presence within Ahrefs' monitored prompt test-bed*.
- Never guarantee that an unmonitored user prompt in ChatGPT or Gemini will cite the brand.
- Distinguish between domain citations (domain URL cited in search card) and unlinked brand mentions in LLM text generation.

---

## 4. Metric Fallacy 4: Snapshots Do Not Establish Historical Causality

### The Mechanism
Most tools in the Ahrefs MCP suite (`site_overview`, `organic_keywords`, `top_pages`, `content_gap`) return static point-in-time snapshots of current index rankings.

### The Fallacy
1. Observing a low ranking (e.g., position 38) and claiming: "This page dropped because of the recent Google Core Update."
2. Concluding that a page with zero organic traffic was penalized or suffered content decay without examining historical traffic deltas.

### The Boundary & Truth Standard
- A snapshot proves *current state*, never *historical trajectory*.
- To investigate content decay or traffic loss:
  - Inspect historical deltas (`trafficChange`) where supported.
  - Formulate drop explanations as Level 4 Hypotheses to be cross-referenced with Google Search Console data or algorithm update dates.
  - Never assert an algorithmic penalty without confirming a sudden, sitewide indexation drop across brand and non-brand queries.
