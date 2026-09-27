# Workflow: Competitor Market Conquesting

## 1. Objective & Hypothesis
Compare target domain authority and commercial keyword footprint against 2 to 5 primary competitors to isolate high-intent keyword gaps and commercial opportunities.

---

## 2. Execution Pipeline

### Step 1: Modular Benchmark Audit
Call `ahrefs_benchmark` with selected components to prevent timeouts:
```json
{
  "target": "mybrand.com",
  "competitors": ["rival1.com", "rival2.com", "rival3.com"],
  "country": "us",
  "components": ["overview", "content_gap"]
}
```

### Step 2: Coverage Ledger Audit
Inspect `coverage.domainOutcomes`. If one competitor failed (`status: "failed"` due to timeout), proceed with the successful domains and disclose the missing data. Do NOT re-run the benchmark.

### Step 3: Targeted Content Gap
If deep keyword gaps are needed, call `ahrefs_content_gap`:
```json
{
  "target": "mybrand.com",
  "competitors": ["rival1.com", "rival2.com"],
  "country": "us",
  "limit": 100,
  "minVolume": 200
}
```
Query the resulting `exp_<uuid>` with `ahrefs_query_artifact` to isolate low-KD gaps:
```json
{
  "id": "exp_<uuid>",
  "filters": [
    { "field": "difficulty", "operator": "lte", "value": 30 }
  ],
  "sort": { "field": "volume", "direction": "desc" }
}
```

---

## 3. Scoring & Prioritization: CCGS
Calculate the **Commercial Content Gap Score (CCGS)**:
$$\text{CCGS} = \frac{\text{Search Volume} \times (\text{Competitor Overlap Count})^2}{\text{KD} + 1} \times \text{Intent Multiplier}$$
*(Intent Multipliers: BoFu/Transactional = 3.0, MoFu/Commercial = 2.0, ToFu/Informational = 1.0)*

### Handoff Deliverables
1. **Comparative Authority Stance**: Target DR vs Competitor Logarithmic Mean.
2. **Gap Matrix**: Prioritized list of BoFu/MoFu topics with estimated traffic potential.
3. **Execution Horizon**: P0 vs P1 content creation roadmap.
