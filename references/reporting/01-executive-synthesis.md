# Executive SEO Synthesis & Presentation Playbook

## 1. The Executive Glanceability Standard

Senior stakeholders and marketing executives do not read raw JSON or 50-row uncurated data dumps. Every SEO analysis delivered through this skill must follow the **Executive Glanceability Standard**:

1. **Lead with Bottom-Line Business Impact**: Start with Organic Traffic, Traffic Value ($ USD estimate), striking distance revenue potential, and Domain Rating (DR).
2. **Intent-Driven Architecture**: Segment keywords and pages into ToFu (Top of Funnel / Informational), MoFu (Middle of Funnel / Commercial Investigation), and BoFu (Bottom of Funnel / High-Intent Transactional).
3. **Prioritized Action Matrix**: Group all recommendations into P0 (Immediate Quick Wins / Sprint 1), P1 (Quarterly Content & Scaling), and P2 (Authority & Digital PR Moat).
4. **Data Integrity & Formatting**:
   - Align numbers to the right in Markdown tables.
   - Use em-dash (`—`) for unmeasured or absent metrics; never display `0`, `NaN`, or `null` for unmeasured data.
   - Include direct calculations of incremental traffic value where relevant.

---

## 2. Executive Scorecard Template

Every comprehensive audit or benchmark report must open with an Executive Glanceability Scorecard:

```markdown
### 📊 Executive Organic Performance Scorecard

| Metric | Target Domain (`example.com`) | Market Leader (`competitor.com`) | Variance / Gap | Strategic Interpretation |
|:---|---:|---:|---:|:---|
| **Domain Rating (DR)** | 48 | 64 | -16 pts | Logarithmic authority deficit; requires high-DR PR link acquisition. |
| **Referring Domains** | 320 | 1,450 | -1,130 RDs | Competitor possesses 4.5x more root linking domains. |
| **Organic Traffic (Mo.)** | 42,500 | 185,000 | -142,500 | 77% traffic gap primarily driven by category pillar deficit. |
| **Organic Traffic Value** | $38,200 | $215,000 | -$176,800/mo | Significant commercial monetization gap in BoFu terms. |
| **Striking Distance Pool** | 38 terms | 112 terms | — | $14,200/mo near-term unlock potential in positions 4–15. |
```

---

## 3. Search Intent Mapping (ToFu / MoFu / BoFu)

Categorize all keyword and topic findings according to commercial intent:

| Funnel Stage | Intent Flags | Typical CPC / Value | Strategy | Example Keyword |
|:---|:---|:---|:---|:---|
| **BoFu (High Intent)** | Transactional (`T`), Commercial (`C`) with high CPC ($3+) | Very High | Direct conversion landing pages, pricing tables, product comparison matrices. | "enterprise crm pricing", "buy email marketing tool" |
| **MoFu (Evaluation)** | Commercial (`C`), Informational (`I`) with "best", "vs", "review" | Medium–High | In-depth comparison guides, feature checklists, buyer's guides. | "hubspot vs salesforce for b2b", "best rank tracking software" |
| **ToFu (Awareness)** | Informational (`I`), zero/low CPC | Low–Medium | Comprehensive ultimate guides, glossary definitions, topic cluster pillars. | "what is seo", "how to calculate customer acquisition cost" |

---

## 4. Opportunity Scoring Reference

When ranking recommendations, use standardized quantitative scoring frameworks:

### Striking Distance Opportunity Score (SDOS)
$$\text{SDOS} = \frac{\text{Volume} \times \text{CPC}}{\text{Position} \times (\text{KD} + 1)}$$
- **High Priority**: $\text{SDOS} > 150$ (High volume, high commercial value, weak keyword difficulty).
- **Medium Priority**: $50 \le \text{SDOS} \le 150$.
- **Low Priority**: $\text{SDOS} < 50$.

### Competitor Conquesting Score (CCGS)
$$\text{CCGS} = \frac{\text{Volume} \times \text{Top Competitor Position Factor}}{\text{Target KD} + 1}$$
Where Top Competitor Position Factor is:
- Position 1: $1.0$
- Position 2–3: $0.8$
- Position 4–10: $0.5$

---

## 5. Three-Tier Prioritization Framework (P0 / P1 / P2)

Structure implementation roadmaps into three clear execution horizons:

### P0: Immediate Sprint (Weeks 1–3) — Zero/Low Development Cost
- **Target**: Striking distance keywords in positions 4–10 with high volume and commercial intent.
- **Action**: On-page optimization:
  - Title tag and H1 intent sharpening.
  - Adding internal links from highest-authority top pages (`ahrefs_top_pages`).
  - Answering missing user questions discovered via `ahrefs_keyword_overview`.
- **Expected ROI**: First traffic lifts visible within 14–28 days.

### P1: Quarterly Content & Architecture (Months 1–3) — Content Production
- **Target**: High-volume competitor content gaps (`ahrefs_content_gap`) where competitors rank on Page 1 but target is unranked.
- **Action**: Net-new pillar and cluster content creation:
  - Producing comprehensive 2,500+ word category guides.
  - Creating comparison/alternative pages (`/vs/`, `/alternatives/`) targeting commercial keywords.
  - Implementing structured schema (`FAQPage`, `Product`, `Article`) to capture AI Overview citations.
- **Expected ROI**: Significant traffic footprint expansion within 60–90 days.

### P2: Authority & Digital PR Moat (Months 2–6) — Link Acquisition
- **Target**: High-DR referring domains discovered via `ahrefs_link_intersect` that link to multiple competitors but not the target.
- **Action**: Digital PR and outreach campaigns:
  - Industry benchmark studies, proprietary data reports, or free interactive tools.
  - Targeted outreach to unlinked brand mentions or competitor resource pages.
- **Expected ROI**: Sustained Domain Rating (DR) elevation, closing the long-term domain authority gap.
