# Stopping Rules & Analytical Depth Calibration

## 1. Depth Calibration: Matching Effort to Intent

An autonomous agent must calibrate analytical depth strictly to the scope of the user's objective:

| Scope Tier | User Prompt Type | Target Tool Call Count | Expected Execution Pattern |
|:---|:---|:---:|:---|
| **Tier 1: Narrow Factual** | "What is stripe.com's DR?" | **1** | Single targeted lookup (`ahrefs_site_overview`). Zero exploratory follow-ups. Immediate direct answer. |
| **Tier 2: Single Entity Qualifying** | "Evaluate difficulty and questions for keyword 'headless cms'" | **1–2** | Single tool (`ahrefs_keyword_overview`). Enrich with questions. Deliver concise evaluation card. |
| **Tier 3: Targeted Workflow** | "Find striking distance keywords for our site" | **2–3** | `ahrefs_organic_keywords` -> `ahrefs_query_artifact` (filter pos 4–15) -> `ahrefs_top_pages` (donor URLs). Deliver prioritized table. |
| **Tier 4: Broad Strategic Audit** | "Perform a competitive SEO audit and identify our growth roadmap" | **4–7** | Multi-step pipeline: `ahrefs_benchmark(components: ["overview"])` -> `ahrefs_content_gap` -> `ahrefs_link_intersect` -> `ahrefs_query_artifact` -> `ahrefs_keyword_overview_batch` -> Executive Synthesis. |

---

## 2. The Formal Stopping Rule

The agent halts an investigation when and only when one of the following four conditions is satisfied:

1. **Evidence Sufficiency (Success)**:
   - Every claim in the proposed strategy is directly supported by retrieved Level 1 observations.
   - The primary strategic deliverable (e.g., top content gaps, quick-win keywords, link prospects) is populated with verified metrics.
2. **Diminishing Returns (Efficiency)**:
   - Further tool invocations will yield duplicate or marginally incremental data that does not materially change the strategic recommendations.
   - Example: Running individual keyword overviews for 30 long-tail variations when the top 5 high-volume pillar terms already define the content direction.
3. **Hard System / Upstream Boundary (Circuit Breaker)**:
   - Authentication failed and the 1-retry budget via `ahrefs_auth_login(relogin: true)` was exhausted.
   - Upstream API rate limits or Cloudflare 524 timeouts persist.
   - The user requested data that Ahrefs does not track (e.g., real-time Google Search Console click-through curves or server log files).
4. **Disclosed Data Exhaustion**:
   - The target domain has zero ranking keywords or backlinks in the requested database, verified through `totalRows === 0` and confirmed absence across broader scopes.

---

## 3. Pathologies to Avoid

### Pathology A: Premature Abandonment
- **Symptom**: Calling `ahrefs_benchmark` once, printing the summary table, and declaring: "Audit complete. Your competitors have more traffic."
- **Correction**: A benchmark summary is a diagnostic pointer, not a strategic deliverable. Dig into specific content gaps (`ahrefs_content_gap`) and authority gaps (`ahrefs_link_intersect`) to uncover *how* the competitor is winning.

### Pathology B: Unbounded Rabbit Holes
- **Symptom**: Making 25 consecutive individual tool calls to look up every single keyword and backlink one by one.
- **Correction**: Leverage batch tools (`ahrefs_keyword_overview_batch`, `ahrefs_site_overview_batch`) and local artifact querying (`ahrefs_query_artifact`). Isolate the top 10–20 high-impact candidates before spending paid API credits.

### Pathology C: Arbitrary Call Limits
- **Symptom**: Halting after call 3 or call 5 simply because of an arbitrary rule, leaving critical gaps unanalyzed.
- **Correction**: Proceed autonomously through the planned evidence chain without interrupting the user for routine permission.
