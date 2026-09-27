# Scenario: Multi-Market Batch Keyword Enrichment

## Context & Scenario Brief
A B2B software vendor wants to evaluate search demand and keyword difficulty for 3 core terms across 2 major markets (US and UK):
- Keywords: `"ai customer service"`, `"help desk automation"`, `"support ticketing software"`.
- Markets: United States (`"us"`), United Kingdom (`"gb"`).

---

## Step 1: Formulating the Batch Invocations

Because `ahrefs_keyword_overview_batch` is scoped to a single country database per batch call, the agent issues two structured batch calls:

```json
// Call 1: US Market Batch
// Tool: ahrefs_keyword_overview_batch
{
  "requests": [
    { "requestId": "us-ai-cs", "keyword": "ai customer service", "country": "us" },
    { "requestId": "us-helpdesk", "keyword": "help desk automation", "country": "us" },
    { "requestId": "us-ticketing", "keyword": "support ticketing software", "country": "us" }
  ]
}

// Call 2: UK Market Batch
// Tool: ahrefs_keyword_overview_batch
{
  "requests": [
    { "requestId": "gb-ai-cs", "keyword": "ai customer service", "country": "gb" },
    { "requestId": "gb-helpdesk", "keyword": "help desk automation", "country": "gb" },
    { "requestId": "gb-ticketing", "keyword": "support ticketing software", "country": "gb" }
  ]
}
```

---

## Step 2: Correlated Reconciliation Matrix

The agent correlates results using `requestId` and synthesizes the comparative market matrix:

| Keyword | US Volume | US KD | US CPC | UK Volume | UK KD | UK CPC | Strategic Insight |
|:---|---:|---:|---:|---:|---:|---:|:---|
| `ai customer service` | 14,000 | 48 | \$18.50 | 2,400 | 36 | £12.20 | UK offers 25% lower ranking friction with strong commercial intent. |
| `help desk automation` | 3,200 | 32 | \$14.00 | 650 | 24 | £9.80 | High CPC in both markets; ideal for product comparison landing pages. |
| `support ticketing software` | 8,100 | 62 | \$22.00 | 1,600 | 54 | £16.50 | Saturated authority barrier in US (KD 62); prioritize UK cluster first. |

**Key Takeaway**: Batch tools reduce 6 separate network turns to 2 clean, correlated batch operations.
