# Economic Awareness, Quotas & Investigation Depth

## 1. Tool Economic Classification

Every programmatic agent operating `ahrefs-mcp` must operate with complete fiscal and infrastructure consciousness:

| Tier | Tools | Cost & Infrastructure | Latency | Policy |
| :--- | :--- | :--- | :--- | :--- |
| **FREE** | `ping`<br>`ahrefs_auth_status`<br>`ahrefs_read_artifact`<br>`ahrefs_query_artifact` | Zero spend, zero browser lease, local in-memory operation. | < 50ms | Call freely for verification, status check, or data slicing. |
| **PAID** | `ahrefs_site_overview`<br>`ahrefs_site_overview_batch`<br>`ahrefs_ai_visibility`<br>`ahrefs_keyword_overview`<br>`ahrefs_keyword_overview_batch`<br>`ahrefs_organic_keywords`<br>`ahrefs_top_pages`<br>`ahrefs_backlinks`<br>`ahrefs_content_gap`<br>`ahrefs_link_intersect`<br>`ahrefs_benchmark` | Paid Ahrefs query driving headless Chromium via Kernel. | 15–45s | Must be hypothesis-driven. Use batching where possible. |
| **MUTATING** | `ahrefs_auth_login`<br>`ahrefs_auth_logout`<br>`ahrefs_auth_controls` | Modifies global shared session state. | 5–20s | Call ONLY when recovering from verified 401 / `session_expired` under strict 1-retry budget. |

---

## 2. The "One Tool Call = One Paid Query" Invariant

- Every live extraction tool execution triggers a discrete browser automation lifecycle against Ahrefs.
- **Zero Blind Retries**: If a call fails with a typed error (`UpstreamTimeout`, `InvalidTargetDomain`, `NoResults`, `AuthFailure`), inspect the diagnostic reason before acting. Repeating the exact same parameters will only burn credits and time.
- **Filter Upfront vs Post-Capture**: Apply parameters directly, but be aware of `filterStage: "post_capture"` (see retrieval metadata reference).

---

## 3. Investigation Depth: Proportionality, Not Arbitrary Ceilings

- **No Artificial 3/5/15 Call Caps**: There is no arbitrary rule that requires halting after 3 or 5 calls or asking for permission at 15 calls.
- **Proportionality Principle**:
  - *Narrow Queries* ("What is Stripe's DR?"): Require exactly 1 surgical tool call (`ahrefs_site_overview`). Do not expand without necessity.
  - *Strategic Inquiries* ("Audit our organic decay", "Find our best growth vectors", "Benchmark against 3 rivals"): Warrant deep multi-step investigation across authority, content gaps, backlink profiles, and SERP features.
- **Stopping Criteria**:
  - Stop when the business objective is fully answered with empirical evidence.
  - Stop when an unrecoverable error occurs (e.g. invalid credentials after 1 retry).
  - Stop when a true material decision is required from the user that cannot be resolved via disclosed assumptions.
