# Scenario: Biased Acquisition Recovery & Filter Clipping

## Context & Scenario Brief
The agent is tasked with finding high-intent commercial content gaps for `target.com` against `rival.com`.

---

## Step 1: Biased Capture & Empty Filter Syndrome

The agent requests a content gap capture sorted by search volume:

```json
// Tool: ahrefs_content_gap
{
  "target": "target.com",
  "competitors": ["rival.com"],
  "country": "us",
  "limit": 50,
  "intent": "commercial"
}
```

**Returned Output**:
- `totalRows`: 0
- `rows`: []
- `retrievalMetadata`:
  - `capturedRowCount`: 50
  - `returnedRowCount`: 0
  - `filterStage`: `"post_capture"`
  - `warnings`: ["intent filter 'commercial' applied post-capture against 50 rows"]

---

## Step 2: Epistemic Triage

- **Naive Agent Error**: Concluding *"Rival.com has zero commercial content gaps against target.com."*
- **Epistemically Rigorous Agent**: Inspects `retrievalMetadata`:
  - 50 rows were captured upstream.
  - All 50 were broad, top-of-funnel informational terms (`"what is cloud"`, `"free tools"`) because volume sorting naturally prioritizes informational head terms.
  - Post-capture filtering removed all 50 rows, leaving zero.

---

## Step 3: Calibrated Re-Acquisition

The agent re-captures with an expanded limit to allow commercial terms to enter the candidate pool, or removes the upstream intent filter to inspect the distribution:

```json
// Tool: ahrefs_content_gap
{
  "target": "target.com",
  "competitors": ["rival.com"],
  "country": "us",
  "limit": 300
}
```

Now, querying the resulting artifact with `ahrefs_query_artifact(filters: [{ field: "intent", operator: "eq", value: "commercial" }])` reveals **42 high-value commercial keywords** (`"enterprise cloud migration"`, `"aws cost calculator"`).

**Key Takeaway**: Never confuse post-capture filter emptiness with population absence.
