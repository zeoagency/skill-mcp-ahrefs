# Rate Limiting, Timeouts & Transient Backoff

## 1. Error Taxonomy & Handling Matrix

| Error Code | Root Cause | Retryable? | Immediate Agent Action |
|:---|:---|:---:|:---|
| `rate_limit_exceeded` (429) | Upstream Ahrefs query threshold exceeded. | **Yes** (with backoff) | Pause execution. Apply exponential backoff (5s -> 10s). Max 2 retries. |
| `upstream_timeout` (524) | Extraction exceeded 90-second Cloudflare proxy deadline. | **Conditional** | Do NOT retry identical query. Split workload: reduce competitor count or use `components: ["overview"]`. |
| `bot_challenge` / `access_denied` | Cloudflare Turnstile or IP captcha triggered. | **No** | Halt immediately. Do not hammer. Inform user that manual operator intervention is required. |
| `session_expired` (401) | Ahrefs browser cookie invalidated. | **Yes** (1 retry) | Call `ahrefs_auth_login(relogin: true)`. If successful, retry query once. |
| `auth_circuit_broken` | Preceding batch item tripped auth error. | **Yes** (after login) | Re-authenticate, then retry only unattempted items. |

---

## 2. Exponential Backoff Protocol

When encountering `rate_limit_exceeded`:

1. **Calculate Backoff**:
   $$t_{\text{wait}} = \min(5 \times 2^{\text{attempt}}, 30) \text{ seconds}$$
   - Attempt 1: Wait 5 seconds.
   - Attempt 2: Wait 10 seconds.
2. **Maximum Retry Budget**: Strictly 2 retries.
3. **Escalation**: If the query fails a 3rd time, halt execution, state that upstream rate limits are active, and present all partial data gathered so far.

---

## 3. Mitigating 90-Second Timeouts (`upstream_timeout`)

The 90-second Cloudflare proxy deadline is a hard transport limit. If a complex tool (such as `ahrefs_benchmark`) times out:

1. **Diagnose Workload**:
   - Running 5 competitors with full content gap and link intersect sub-reports requires 7 browser page loads.
   - If upstream latency is high, this easily breaches 90 seconds.
2. **Apply Modular Remediation**:
   - Rerun `ahrefs_benchmark` specifying `components: ["overview"]`. This cuts required page loads to 2, completing in under 30 seconds.
   - Query deep content gaps independently using `ahrefs_content_gap` for the single most important competitor.
