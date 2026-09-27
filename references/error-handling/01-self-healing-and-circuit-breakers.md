# Error Handling: Self-Healing State Machine & Circuit Breakers

## 1. Upstream Session Expiration (401 / `session_expired`)

The server attempts automatic in-process re-authentication via its self-heal coordinator. If that fails, a typed `session_expired` error is returned.

### The 1-Retry Recovery Protocol
```
[ Tool Call Throws Session Expired ]
                │
                ▼
  [ Call ahrefs_auth_status ] (Optional: inspect config)
                │
                ▼
   [ Call ahrefs_auth_login ]
         relogin: true
                │
      ┌─────────┴─────────┐
      ▼                   ▼
[ Login OK ]        [ Login Failed ]
      │                   │
      ▼                   ▼
[ Retry Call Once ]  [ Terminate & Escalate ]
 (Strict Budget)     Report exact failure reason
```

- **Strict Rule**: You are authorized to call `ahrefs_auth_login(relogin: true)` **at most once** per turn upon receiving an auth error.
- If login succeeds, retry the original failed operation **once**. If it fails again, stop and report. Never loop.

---

## 2. Batch Circuit Breakers (`auth_circuit_broken`)

In `ahrefs_site_overview_batch` and `ahrefs_keyword_overview_batch`:
- If item 1 or item $N$ fails with an authentication error (`session_expired`) or rate-limit trip:
- The server trips its internal circuit breaker.
- Remaining items in the batch are short-circuited with `status: "auth_circuit_broken"`.
- **Action**: Do NOT attempt to run the remaining items individually. Execute the 1-retry auth recovery first.

---

## 3. Rate Limits (429) & Long-Call Timeouts (524)

- Calls exceeding 5 seconds automatically switch to Server-Sent Events (SSE) keepalives to prevent Cloudflare 524 timeouts.
- If an error contains `RETRY_TRANSIENT`: apply exponential backoff (Retry 1: 5s, Retry 2: 15s; max 2 retries).
- If an error contains `RETRY_UNLIKELY`: do NOT retry. Report immediately.
