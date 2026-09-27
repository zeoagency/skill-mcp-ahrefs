# Scenario: Modular Benchmark Optimization & 90s Timeout Prevention

## Context & Scenario Brief
A client requests an executive authority benchmark:
*"Compare our domain (`brand.com`) against our 4 primary competitors (`comp1.com`, `comp2.com`, `comp3.com`, `comp4.com`)."*

---

## Step 1: Workload & Timeout Risk Assessment

- **Total Domains**: 5 domains (1 target + 4 competitors).
- **Default Full Benchmark**: Executes 5 overview scrapes + 1 multi-domain content gap + 1 link intersect = **7 browser page cycles**.
- **Latency Risk**: Sequential browser execution averages 12–20s per cycle. Total execution: $7 \times 15\text{s} \approx 105\text{s}$. This exceeds the 90-second Cloudflare proxy deadline (`upstream_timeout`).

---

## Step 2: Applying Modular Optimization

The agent specifies `components: ["overview"]` to omit the heavy multi-domain gap calculations:

```json
// Tool: ahrefs_benchmark
{
  "target": "brand.com",
  "competitors": ["comp1.com", "comp2.com", "comp3.com", "comp4.com"],
  "components": ["overview"]
}
```

**Outcome**: Completes in 28 seconds (zero timeout risk) and returns the full 5-domain authority and traffic matrix:

| Domain | Role | Status | DR | Org. Traffic | Org. Keywords | Backlinks | AI Citations |
|:---|:---:|:---:|---:|---:|---:|---:|---:|
| `brand.com` | Target | `ok` | 44 | 28,000 | 4,200 | 850 | 14 |
| `comp1.com` | Competitor | `ok` | 68 | 210,000 | 38,000 | 14,200 | 185 |
| `comp2.com` | Competitor | `ok` | 52 | 64,000 | 11,200 | 2,400 | 38 |
| `comp3.com` | Competitor | `ok` | 49 | 41,000 | 7,800 | 1,650 | 22 |
| `comp4.com` | Competitor | `ok` | 38 | 14,500 | 2,100 | 480 | — |

**Leader**: `comp1.com` dominates traffic, authority, and AI visibility.

---

## Step 3: Targeted Deep-Dive

Now that `comp1.com` is established as the sole primary category threat, the agent runs a targeted content gap against ONLY `comp1.com`:

```json
// Tool: ahrefs_content_gap
{
  "target": "brand.com",
  "competitors": ["comp1.com"],
  "limit": 100
}
```

**Key Takeaway**: Modular components prevent 90s deadline timeouts while delivering full strategic clarity.
