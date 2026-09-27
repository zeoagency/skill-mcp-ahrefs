# Workflow: Backlink Profile Health & Anchor Text Audit

## 1. Executive Objective
Evaluate the structural integrity, authority distribution, and anchor text profile of inbound backlinks to detect algorithmic penalty risks (over-optimized commercial anchors) and assess link acquisition velocity.

---

## 2. Tool Execution Chain

```
[Step 1: Macro Authority Assessment] ──► ahrefs_site_overview(domain: target)
                 │
                 ▼
[Step 2: Representative Inbound Links] ──► ahrefs_backlinks(
                   domain: target,
                   grouping: "onePerDomain",
                   sort: "dr",
                   limit: 200
                 )
                 │
                 ▼
[Step 3: Anchor Text Distribution] ──► ahrefs_query_artifact(
                   select: ["anchor", "referringDomain", "dr", "linkType"]
                 )
```

---

## 3. Anchor Text Risk Thresholds

Algorithmic link evaluation algorithms (Google Penguin / SpamBrain) penalize unnatural backlink profiles. Evaluate the anchor distribution against these thresholds:

| Anchor Category | Description & Examples | Healthy Range | Danger / Penalty Threshold |
|:---|:---|:---:|:---:|
| **Brand Anchors** | `"Stripe"`, `"stripe.com"`, `"Stripe Payments"` | $50\% - 70\%$ | $<30\%$ (signals manipulation) |
| **Compound / Hybrid** | `"Stripe billing software"`, `"read on Stripe"` | $15\% - 25\%$ | — |
| **Generic / Miscellaneous** | `"visit website"`, `"source"`, `"click here"` | $10\% - 20\%$ | $<5\%$ |
| **Exact-Match Commercial** | `"best crm"`, `"cheap email marketing tool"` | **$<5\%$** | **$>15\%$ (Extreme Penguin Risk)** |

---

## 4. Link Profile Health Metrics
1. **Dofollow Ratio**: Healthy sites typically maintain a $65\% - 85\%$ Dofollow ratio. A $100\%$ dofollow profile looks artificial.
2. **Referring Domain to Backlink Ratio**: A ratio of 1 RD to 500 backlinks suggests sitewide footer or sidebar spam. Aim for a healthy spread across diverse root domains.
3. **Domain Authority Spread**: High concentration in DR 0–10 domains with zero DR 50+ editorial mentions indicates low-quality syndication networks.
