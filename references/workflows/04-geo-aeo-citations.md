# Workflow: Generative Engine Optimization (GEO/AEO) & AI Citations

## 1. Objective & Hypothesis
Audit brand citation share across monitored Generative AI models (ChatGPT, Perplexity, Google AI Overviews) and identify strategic prompt/topic areas where competitors dominate AI-generated recommendations.

---

## 2. Execution Pipeline

### Step 1: Extract AI Visibility Footprint
Call `ahrefs_ai_visibility` for the target and primary competitors:
```json
{
  "domain": "targetbrand.com"
}
```

### Step 2: Compare Platform Share & Citations
Examine:
- `totalCitations` vs competitor citation volume.
- `sentimentBreakdown` (positive, neutral, negative brand perception).
- `topCitedQueries[]`: The specific user prompts triggering citations.

### Step 3: Batch Verify Search Demand for AI Topics
Select high-citation queries where your brand is absent. Call `ahrefs_keyword_overview_batch` to check if these prompts have corresponding search volume in Google:
```json
{
  "requests": [
    { "keyword": "best crm for enterprise", "country": "us" },
    { "keyword": "crm software comparison", "country": "us" }
  ]
}
```

---

## 3. AEO Strategic Playbook
1. **Entity Schema Markup**: Implement structured Organization, Product, and Article schemas with `sameAs` links to authoritative Wikidata and Crunchbase entities.
2. **Direct Answer Architecture**: Structure landing page sections with concise, 40-word declarative definitions ("What is X?") to facilitate LLM retrieval-augmented generation (RAG) extraction.
3. **Digital PR Entity Seeding**: Seed brand mentions across high-citation third-party media sources cited frequently by Perplexity and Google AI Overviews.
