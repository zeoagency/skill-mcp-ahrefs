# Workflow: Topic Clustering & Pillar-Cluster Architecture

## 1. Objective & Hypothesis
Construct an entity-first, mathematically validated Topic Cluster (1 authoritative Pillar Page + 6 to 10 supporting Cluster Articles) that establishes unquestioned topical authority in a target domain vertical while preventing keyword cannibalization.

---

## 2. Execution Pipeline

### Step 1: Head Topic & Parent Entity Validation
Call `ahrefs_keyword_overview`:
```json
{
  "keyword": "marketing automation",
  "country": "us"
}
```
Extract:
- `parentTopic.topic`: Confirms the core entity head.
- `volume` & `trafficPotential`: Sizing total cluster addressable demand.
- `matchingTerms[]` & `questions[]`: Raw candidates for supporting cluster articles.

### Step 2: Content Gap Topic Mining
Call `ahrefs_content_gap` against 2 competitors for this specific category to identify sub-topics covered by rivals:
```json
{
  "target": "mybrand.com",
  "competitors": ["rival1.com", "rival2.com"],
  "country": "us",
  "limit": 100,
  "minVolume": 200
}
```

### Step 3: Keyword Cannibalization Pre-Check
Call `ahrefs_organic_keywords` on your target domain:
```json
{
  "domain": "mybrand.com",
  "limit": 300
}
```
Query artifact for candidate cluster keywords. If an existing URL already ranks in positions 1–20, designate that existing URL as the cluster asset (content refresh) rather than creating a competing duplicate page.

---

## 3. Pillar-Cluster Blueprint Structure
- **Central Pillar Asset (`/solutions/marketing-automation`)**:
  - Targets Head Query and Primary Parent Topic.
  - Comprehensive guide with bidirectional links to all 6–10 cluster articles.
- **Cluster Sub-Pages (`/solutions/marketing-automation/b2b-strategies`)**:
  - Targets specific long-tail questions and commercial variations.
  - Every cluster page links back to the Central Pillar with the exact primary keyword as anchor text.
