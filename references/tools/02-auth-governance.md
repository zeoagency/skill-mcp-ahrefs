# Tool Playbook: Authentication & Session Governance

## 1. `ahrefs_auth_status`
- **Economic Classification**: FREE (Read-only, zero browser lease).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Inspect the current Ahrefs session state and login configuration without mutating sessions.
- **Parameters**: `{}` (Takes no arguments).
- **Call When**: Pre-flight verification before launching multi-step batch workflows, or diagnosing whether credentials are configured upon receiving errors.
- **Outputs**:
  ```typescript
  {
    configured: boolean;    // Credentials/mode configured in environment
    authenticated: boolean; // Live session verified
    loginMode?: "password" | "code" | "link";
    profileName?: string;
    inbox?: string;
    lastVerifiedAt?: string;
    lastError?: string;
    fields?: Array<{ key: string, field: string, value?: string }>;
  }
  ```

---

## 2. `ahrefs_auth_login`
- **Economic Classification**: MUTATING (Drives browser automation session).
- **Annotations**: `readOnlyHint: false`, `destructiveHint: false`, `idempotentHint: false`, `openWorldHint: false`.
- **Purpose**: Authenticate with Ahrefs using configured server credentials.
- **Parameters**:
  ```typescript
  {
    relogin?: boolean; // When true, forces a fresh login even if session cookie is present. Default: false.
  }
  ```
- **The Strict 1-Retry Budget Law**:
  - Never call `ahrefs_auth_login` routinely before analytical data calls.
  - Call ONLY after receiving a typed `session_expired` or HTTP 401 error.
  - If login succeeds, retry the original failed data call **at most once**.
  - If login fails or the retry fails, terminate immediately with an unrecoverable auth error. Never loop.

---

## 3. `ahrefs_auth_logout`
- **Economic Classification**: MUTATING & DESTRUCTIVE.
- **Annotations**: `readOnlyHint: false`, `destructiveHint: true`, `idempotentHint: false`, `openWorldHint: false`.
- **Purpose**: Clear session cookies and browser profile leases across the server.
- **Parameters**: `{}`.
- **Guardrail**: Never invoke as an analytical cleanup step. Use only when explicitly commanded by administrative policy.

---

## 4. `ahrefs_auth_controls` (Legacy Unified Controller)
- **Economic Classification**: MUTATING / FREE (Deprecated in favor of split auth tools; preserved for backward compatibility).
- **Annotations**: `readOnlyHint: false`, `destructiveHint: true`, `idempotentHint: false`, `openWorldHint: false`.
- **Parameters**:
  ```typescript
  {
    action: "status" | "login" | "logout"; // Required discriminator
    relogin?: boolean; // Only permitted when action === 'login'
  }
  ```
- **Error Guardrail**: Passing `relogin` with `action: "status"` or `"logout"` throws an immediate validation error.
