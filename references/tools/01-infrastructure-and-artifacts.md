# Tool Playbook: Infrastructure & Artifacts (Free)

## 1. `ping`
- **Economic Classification**: FREE (Local in-memory probe).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Verify that the MCP server process is responding.
- **Parameters**:
  ```typescript
  {
    message?: string; // Optional echo text (max 200 chars). Omit for 'pong'.
  }
  ```
- **Call When**: Initial pipeline bootstrap, after connection timeout, or post-deploy health check.
- **Never Call When**: Routinely before every data query (wastes turns). Keep secrets out of `message`.
- **Outputs**: `{ status: "pong", server: "ahrefs-mcp", version: "1.0.0", timestamp: string }`.

---

## 2. `ahrefs_read_artifact`
- **Economic Classification**: FREE (Local reportStore lookup).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Read chunks of stored benchmark reports (`run_<uuid>`) or CSV tables (`exp_<uuid>`).
- **Parameters**:
  ```typescript
  {
    kind: "report" | "export"; // Required discriminator
    id: string;                // Bare ID: run_<uuid> or exp_<uuid> (never pass ahrefs:// URI)
    // REPORT-ONLY PARAMETERS:
    format?: "markdown" | "json"; // Default: 'markdown'
    offset?: number;              // Character offset (default: 0)
    maxChars?: number;            // Max characters per chunk (default: 20000, max: 50000)
    // EXPORT-ONLY PARAMETERS:
    rowOffset?: number;           // Data-row index (default: 0)
    rowLimit?: number;            // Rows per chunk (default: 200, max: 1000)
  }
  ```
- **Strict Parameter Segregation**:
  - `kind: "export"`: FORBIDDEN to pass `format`, `offset`, or `maxChars`.
  - `kind: "report"`: FORBIDDEN to pass `rowOffset` or `rowLimit`.
- **Outputs**: `{ kind, id, mimeType, chunk, returned, total, truncated, nextOffset?, nextRowOffset?, artifactMetadata? }`.
- **Artifact Metadata**: `{ kind, id, rowCount, columnCount, columns }`.

---

## 3. `ahrefs_query_artifact`
- **Economic Classification**: FREE (In-memory structured query over cached datasets).
- **Annotations**: `readOnlyHint: true`, `destructiveHint: false`, `idempotentHint: true`, `openWorldHint: false`.
- **Purpose**: Query, filter, sort, and project stored datasets locally without spending Ahrefs credits or overloading model context.
- **Parameters**:
  ```typescript
  {
    id: string;                   // Bare exp_<uuid> or run_<uuid> (required)
    select?: string[];            // Field names to project (e.g. ['keyword', 'position', 'volume'])
    filters?: Array<{             // Filter conditions evaluated conjunctively (AND)
      field: string;              // Column name (NOTE: parameter is 'field', not 'column')
      operator: "eq" | "neq" | "gt" | "gte" | "lt" | "lte" | "contains" | "in";
      value: unknown;             // Comparison operand
    }>;
    sort?: {
      field: string;              // Column name to sort by (NOTE: parameter is 'field', not 'column')
      direction?: "asc" | "desc"; // Default: 'desc'
    };
    offset?: number;              // 0-based row offset (default: 0)
    limit?: number;               // Max rows to return (default: 50, max: 200)
  }
  ```
- **Important Differences from Common Assumptions**:
  - Does NOT accept `kind`.
  - Uses `select`, NOT `columns`.
  - Uses `field`, NOT `column`.
  - No generic `search` argument; use `contains` filter on specific textual fields.
- **Outputs**: `{ id, tool, totalMatchedRows, returnedRows, offset, limit, fields, rows, note }`.
