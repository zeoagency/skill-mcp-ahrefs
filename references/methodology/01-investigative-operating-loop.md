# Master Investigative Operating Loop

## 1. The 8-Step Autonomous Operating Loop

To produce rigorous, non-speculative SEO strategy without wasting upstream paid API credits or context tokens, the agent executes an 8-step disciplined investigative loop:

```
[Step 1: Define Finish Line] ──► [Step 2: Evidence Plan] ──► [Step 3: Reuse Artifacts] ──► [Step 4: Acquire Population]
                                                                                                    │
[Step 8: Handoff / Deliver]  ◄── [Step 7: Reconcile]     ◄── [Step 6: Qualify & Enrich] ◄── [Step 5: Inspect Coverage]
```

---

## 2. Step-by-Step Execution Protocol

### Step 1 — Define the Finish Line
- **Objective**: Establish the exact decision or strategic deliverable required by the user before making any tool call.
- **Protocol**:
  - Distinguish narrow factual questions (e.g., "What is the DR of `example.com`?") from broad strategic briefs (e.g., "Find the top content gaps against our primary competitors").
  - Formulate the precise stopping condition: "The investigation is complete when we have identified 10 qualified commercial content gaps with verified search volume and competitor position evidence."

### Step 2 — Build a Concise Evidence Plan
- **Objective**: Map every required claim to an exact empirical data source.
- **Protocol**:
  - Never spray tools speculatively.
  - Determine which tools provide primary evidence (e.g., `ahrefs_content_gap`) and which provide enrichment (e.g., `ahrefs_keyword_overview_batch`).
  - Pre-validate all target hostnames, country codes, and parameters.

### Step 3 — Reuse Before Repeating
- **Objective**: Zero-spend data reuse.
- **Protocol**:
  - Check whether a compatible artifact (`run_<uuid>` or `exp_<uuid>`) was produced earlier in the session.
  - If a recent artifact contains the required entity, query it locally with `ahrefs_query_artifact` rather than launching a redundant paid extraction.

### Step 4 — Acquire a Useful Candidate Population
- **Objective**: Capture a sufficiently broad, unbiased sample from the upstream index.
- **Protocol**:
  - Set `limit` appropriately (typically 100–500 rows when post-capture filters will be applied).
  - Select an upstream `sort` aligned with the objective (`traffic` for top performers, `position` for striking distance, `volume` for broad category demand).
  - Explicitly declare the `country` database or multi-location scope.

### Step 5 — Inspect Coverage Before Interpreting Results
- **Objective**: Prevent false conclusions caused by sampling or filter clipping.
- **Protocol**:
  - Inspect `retrievalMetadata`:
    - `capturedRowCount`: How many rows were extracted before filtering?
    - `returnedRowCount`: How many rows satisfied post-capture criteria?
    - `filterStage`: Confirm whether filtering was upstream or `post_capture`.
    - `warnings`: Check for unsupported or ignored parameters.
  - If `returnedRowCount === 0` while `capturedRowCount === limit`, recognize that criteria were too restrictive; relax thresholds before concluding zero opportunities exist.

### Step 6 — Qualify Locally & Enrich Selectively
- **Objective**: Maximize analytical precision while minimizing token spend.
- **Protocol**:
  - Use `ahrefs_query_artifact` to apply compound filters, calculate distributions, and isolate top candidates.
  - Use `select` to project only necessary columns into LLM context.
  - Take the top 5–20 qualified candidates and enrich them via batch tools (`ahrefs_keyword_overview_batch` or `ahrefs_site_overview_batch`).

### Step 7 — Reconcile & Synthesize
- **Objective**: Synthesize disparate data points into a cohesive, evidence-backed strategy.
- **Protocol**:
  - Reconcile volume, difficulty, CPC, and intent across country databases.
  - Identify conflicting signals (e.g., high volume but zero commercial value).
  - Calculate standardized opportunity scores (SDOS, CCGS).

### Step 8 — Handoff
- **Objective**: Deliver executive-ready intelligence.
- **Protocol**:
  - Open with the Executive Glanceability Scorecard.
  - Provide a transparent P0/P1/P2 implementation matrix.
  - Disclose all methodology assumptions, coverage limits, and unresolved gaps.
