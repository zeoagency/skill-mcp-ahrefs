# Scenario: Narrow vs Broad Investigation Depth Calibration

## Case 1: Narrow Factual Request

### User Prompt
> *"What is the Domain Rating (DR) of github.com?"*

### Anti-Pattern (Over-Engineering / Wasteful Spraying)
- Calling `ahrefs_benchmark` comparing GitHub with GitLab, Bitbucket, and SourceForge.
- Following up with `ahrefs_organic_keywords`, `ahrefs_top_pages`, and `ahrefs_ai_visibility`.
- Generating an 8-page strategic report.
- **Cost**: 4 paid calls, 90 seconds latency, 15,000 tokens wasted.

### Correct Pattern (Surgical Execution)
```json
// Tool: ahrefs_site_overview
{
  "domain": "github.com"
}
```
**Response**:
> "As of the latest Ahrefs index observation, `github.com` has a **Domain Rating (DR) of 96** with approximately 485,000 root referring domains and 4.2 billion total backlinks."
- **Cost**: 1 paid call, 2.5 seconds latency, zero fluff.

---

## Case 2: Broad Strategic Investigation

### User Prompt
> *"Our organic traffic has eroded over the last two quarters. Diagnose where we are losing traffic, identify which competitors are capturing our share, and build an actionable recovery sprint."*

### Anti-Pattern (Superficial Abandonment)
- Calling `ahrefs_site_overview` once.
- Seeing traffic is 42,000.
- Stating: *"Your traffic is 42,000. You should write more blog posts and build more backlinks."*

### Correct Pattern (Autonomous Deep Investigation)

```
[Phase 1: Diagnosis]
  ├── ahrefs_top_pages(target, sort: "traffic", limit: 100)
  └── ahrefs_query_artifact(filter: trafficChange < 0, sort: trafficChange asc)
      ──► Isolates the top 5 URLs suffering 80% of total traffic decline.

[Phase 2: Query-Level Attribution]
  └── ahrefs_organic_keywords(domain: target, sort: "traffic", limit: 200)
      ──► Discovers 12 commercial keywords that dropped from positions 1–3 to positions 6–11.

[Phase 3: Competitive Conquest Identification]
  ├── ahrefs_benchmark(target, competitors: ["rival.com"], components: ["overview"])
  └── ahrefs_content_gap(target, competitors: ["rival.com"], limit: 100)
      ──► Proves competitor captured positions 1–3 on those exact 12 keywords using interactive comparison tools.

[Phase 4: Synthesis & Recovery Plan]
  └── Delivers P0 content refresh plan, internal linking equity redistribution, and schema updates.
```
- **Cost**: 4 targeted calls, 1 free artifact query, producing a verified, C-level recovery roadmap.
