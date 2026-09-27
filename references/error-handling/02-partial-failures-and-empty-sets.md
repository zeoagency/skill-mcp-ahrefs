# Partial Failures & Empty Sets Playbook

## 1. Core Principles: Failure is Never Empty & Absence is Not Zero

In Ahrefs MCP integrations, operations frequently touch multiple upstream data points or domains concurrently (e.g., `ahrefs_benchmark`, `ahrefs_site_overview_batch`, `ahrefs_keyword_overview_batch`). An autonomous agent must never conflate an empty result with a failed operation, nor drop partially successful datasets.

### The Invariants

1. **Failure is Never Empty**:
   - A query that failed due to timeout, rate limits, or upstream outages returns a structured failure descriptor with `isError: true` or a `failure` object.
   - An aggregate multi-domain query (such as `ahrefs_benchmark`) returns a `coverage` ledger detailing exactly which domains succeeded (`status: "ok"`) and which failed (`status: "failed"`).
   - Never infer failure solely because a table has 0 rows. A 0-row response (`totalRows: 0`) is valid empirical data confirming zero presence under the requested filters.
2. **Absence is Not Zero**:
   - Unmeasured metrics are `undefined` (key omitted from payload) and must be rendered as `—` (em-dash), never `0` or `null`.
   - `0` means measured zero (e.g., 0 backlinks verified). `undefined` means the metric was not evaluated or unavailable.

---

## 2. Competitive Benchmark Partial Failures

In `ahrefs_benchmark`, up to 5 domains are evaluated simultaneously across three modular components (`overview`, `content_gap`, `link_intersect`). 

### Benchmark Result Structure

```typescript
interface BenchmarkDomainResult {
  domain: string;
  status: "ok" | "failed";
  overview?: SiteOverviewOutput;
  contentGap?: ContentGapOutput;
  linkIntersect?: LinkIntersectOutput;
  failure?: {
    kind: "upstream_timeout" | "bot_challenge" | "invalid_target" | "upstream" | "aborted";
    message: string;
    retryable: boolean;
  };
}

interface BenchmarkOutput {
  target: string;
  competitors: string[];
  components: Array<"overview" | "content_gap" | "link_intersect">;
  domains: BenchmarkDomainResult[];
  leader?: {
    domain: string;
    metric: string;
    value: number;
  };
  coverage: {
    totalRequested: number;
    successful: number;
    failed: number;
    failedDomains: string[];
  };
}
```

### Partial Failure Handling Protocol

When `coverage.failed > 0` in `ahrefs_benchmark`:

1. **Preserve Successful Domains**:
   - Never discard the benchmark or tell the user the operation failed if at least the target or one competitor succeeded.
   - Synthesize market share, gaps, and metrics for all domains where `status === "ok"`.
2. **Expose the Coverage Ledger**:
   - Explicitly inform the user in the executive summary:
     > "Benchmark completed with partial coverage (2/3 competitors analyzed). Note: `competitor-c.com` failed due to `upstream_timeout` and was omitted from the comparison matrix."
3. **Leader Domain Fallback**:
   - If the anticipated market leader domain failed, do not calculate relative competitive gaps against an unmeasured baseline.
   - Fall back to the highest-scoring successful competitor (`status === "ok"`) and state the adjusted baseline explicitly.
4. **Target Domain Failure Handling**:
   - If the primary `target` domain itself fails, the benchmark cannot establish relative gaps (`content_gap` and `link_intersect` depend on the target).
   - Report the target failure immediately, explain whether `failure.retryable` is true, and offer an isolated retry for just the target domain before initiating full benchmarks.

---

## 3. Batch Tools Partial Failure Semantics

Both `ahrefs_site_overview_batch` and `ahrefs_keyword_overview_batch` process arrays of queries with independent status per item.

### Batch Response Schema

```typescript
interface BatchResponse<T> {
  results: Array<{
    requestId?: string;
    query: string;
    status: "ok" | "failed";
    data?: T;
    error?: {
      code: string;
      message: string;
      retryable: boolean;
    };
  }>;
  summary: {
    total: number;
    succeeded: number;
    failed: number;
  };
}
```

### Batch Error Triage

| Condition | Agent Action |
|---|---|
| `summary.failed === 0` | Proceed to downstream synthesis and ranking. |
| `0 < summary.failed < summary.total` | Process successful items (`status: "ok"`). Log failed items in an "Unmeasured Queries" appendix. Do NOT retry the entire batch. |
| `summary.failed === summary.total` | Check error codes across items. If all failed with `auth_circuit_broken` or `session_expired`, initiate auth recovery via `references/error-handling/01-self-healing-and-circuit-breakers.md`. Otherwise, report systemic upstream downtime. |

---

## 4. Empty Result Sets Triage (`totalRows: 0`)

When a data query succeeds (`isError: false`) but returns zero rows (`rows: []`, `totalRows: 0`), treat this as a high-value empirical signal rather than a system defect.

### Strategic Interpretations of Empty Sets

1. **`ahrefs_organic_keywords` with 0 rows**:
   - **Diagnosis**: The domain is either brand new, penalized, unindexed in the target country, or the filter criteria (`minVolume`, `maxKd`) are too restrictive.
   - **Agent Follow-up**:
     - Check `ahrefs_site_overview`: Does the domain have organic traffic or keywords at all?
     - Relax filter parameters: Drop `minVolume` to 0, increase `limit`, or test without country filter (`country: undefined` or global).
2. **`ahrefs_content_gap` with 0 rows**:
   - **Diagnosis**: The target domain already ranks for all keywords the competitors rank for, OR the competitors share zero keyword footprint in the specified country.
   - **Agent Follow-up**:
     - Test with `intersectionMode: "any"` instead of `"all"`.
     - Broaden the competitor set or verify country relevance.
3. **`ahrefs_link_intersect` with 0 rows**:
   - **Diagnosis**: No single referring domain links to all selected competitors while omitting the target.
   - **Agent Follow-up**:
     - Switch `mode` from `"all"` to `"any"` to uncover domains linking to at least one competitor.
4. **`ahrefs_top_pages` with 0 rows**:
   - **Diagnosis**: The target domain has zero pages driving measured organic traffic in the target database.
   - **Agent Follow-up**:
     - Pivot from page optimization to technical crawlability, indexation auditing, or primary keyword expansion.
