# Subagent Coordination & Multi-Agent Handoffs

## 1. Operating as a Subagent

When an autonomous agent is invoked by an orchestrating parent agent (e.g., via `invoke_subagent` in a multi-agent team), it operates under strict delegation protocols:

1. **Strict Scope Adherence**:
   - Focus exclusively on the delegated analytical mandate (e.g., "Analyze competitor backlink gaps and identify top 10 PR targets").
   - Do not drift into adjacent areas (e.g., rewriting website copy or modifying repository source files).
2. **Dense Semantic Handoff**:
   - Avoid conversational pleasantries, introductory chatter, or meta-commentary.
   - Return structured Markdown with explicit data tables, calculation derivations, and artifact pointers.
3. **Artifact ID Preservation (Zero Data Loss)**:
   - Always include the generated `artifactId` (`run_<uuid>` or `exp_<uuid>`) in the handoff.
   - This allows sibling or parent agents to query (`ahrefs_query_artifact`) or paginate (`ahrefs_read_artifact`) the dataset without repeating paid upstream queries.

---

## 2. Standardized Subagent Handoff Schema

Every completed subagent task must conclude with the following structured sections:

```markdown
### 📋 Subagent Mission Outcome
**Objective**: [Brief 1-sentence summary of the assigned investigation]
**Status**: COMPLETE | PARTIAL | BLOCKED
**Primary Deliverable**: [Core executive finding in 2–3 sentences]

### 📊 Empirical Evidence Table
[Markdown table with right-aligned metrics, exact domains/keywords, and sources]

### 🗄️ Produced Artifact Registry
| Artifact ID | Kind | Producing Tool | Total Rows | Queryable Fields |
|:---|:---|:---|---:|:---|
| `exp_9a12c8...` | Export | `ahrefs_organic_keywords` | 500 | `keyword`, `volume`, `position`, `kd`, `intent` |
| `run_4b77f1...` | Report | `ahrefs_benchmark` | 4 | `domain`, `dr`, `orgTraffic`, `backlinks` |

### ⚠️ Disclosed Assumptions & Evidence Gaps
- **Geographic Scope**: Evaluated in US database; multi-regional demand unverified.
- **Coverage**: Competitor `rival-x.com` hit timeout and was excluded from matrix.
- **Assumptions**: Presumed `/pricing` is the primary conversion URL based on traffic share.

### 🎯 Recommended Strategic Interventions (P0 / P1 / P2)
- **P0**: [Immediate high-impact action]
- **P1**: [Medium-term structural action]
- **P2**: [Long-term authority action]
```

---

## 3. Orchestrating Subagents as a Parent Lead

When acting as the Lead Architect dispatching child subagents:

1. **Clear Division of Ownership**:
   - Assign disjoint tasks across subagents:
     - Subagent A: Technical Domain Baseline & AI Visibility (`site_overview`, `ai_visibility`).
     - Subagent B: Competitor Content Gap Discovery (`content_gap`, `organic_keywords`).
     - Subagent C: Digital PR Link Prospecting (`link_intersect`, `backlinks`).
2. **Sequential Integration Queue**:
   - Integrate subagent findings serially.
   - Reconcile findings across lanes (e.g., verifying whether content gaps identified by Subagent B align with high-traffic pages identified by Subagent A).
3. **Never Discard Artifacts**:
   - Collect and catalog all `exp_*` and `run_*` identifiers in the master session ledger.
