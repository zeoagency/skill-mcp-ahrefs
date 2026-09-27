# Invariant Laws: Absence vs. Zero & Input Validation

## 1. The "Absence is Not Zero" Law (`undefined` vs `0`)

In search data analysis, confusing an unmeasured metric with a zero value is a catastrophic analytical error:

- **`undefined` (Omitted Key / Rendered as `—`)**: Ahrefs did not measure this metric for the specified target, country, or scope. In JSON output, the key is omitted entirely. In markdown tables, it renders strictly as an em-dash (`—`).
  - *Example*: An omitted `paidTraffic` or `paidKeywords` field does not mean the domain has zero paid ads; it means Ahrefs paid search crawlers did not capture paid campaign telemetry for this domain.
  - *Mathematical Rule*: Never coerce `undefined` to `0`. Exclude absent values from averages, sums, and percentage distributions.
- **Measured Zero (`0`)**: Ahrefs actively measured the metric and confirmed its value is mathematically zero.
  - *Example*: A measured `organicTraffic: 0` means the domain was crawled, keywords in the top 100 were checked, and estimated clicks rounded to zero.
- **Measured Absence (`null`)**: In comparative matrices, an explicit `null` indicates a verified non-presence (e.g., `not ranking` in Content Gap matrices, `none` in Link Intersect competitor columns). `null` is never guessed from omission.
- **Silent Ahrefs Placeholder Suppression**: Ahrefs Keywords Explorer historically displays a dummy `0% mobile / 100% desktop` placeholder for keywords lacking hardware telemetry. The server explicitly strips this dummy placeholder; device distribution will be omitted (`undefined`) rather than falsely asserting 100% desktop usage.

---

## 2. The "Validate Before Spend" Law

A bad input must NEVER reach an adapter that leases a paid browser session. Every parameter must pass rigorous pre-flight validation:

### A. Domain Normalization Rules (`normalizeDomain`)
- **Format**: Bare hostname only (e.g., `example.com`, `blog.example.com`, `shop.store.co.uk`).
- **Forbidden Elements**:
  - NO protocols (`http://` or `https://` are auto-stripped if present, but clean inputs should omit them).
  - NO paths (e.g., `example.com/blog/` will fail validation).
  - NO trailing slashes (`example.com/`).
  - NO query parameters or fragments (`example.com?id=1`, `example.com#section`).
  - NO whitespaces, backslashes, or duplicate dots (`..`).
- **Length & Character Boundaries**:
  - Maximum 253 characters.
  - Strictly dot-separated LDH (Letters, Digits, Hyphens) labels ending in an alphabetic TLD of at least 2 characters (`/^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,}$/`).

### B. Country Code Invariants
- Must be a strict **2-letter ISO 3166-1 alpha-2 code** in lowercase (e.g., `'us'`, `'gb'`, `'de'`, `'tr'`, `'fr'`).
- **NEVER** pass 3-letter codes (`'USA'`), country names (`'Germany'`), or continent codes (`'EU'`).
- In `ahrefs_site_overview`, `ahrefs_site_overview_batch`, and `ahrefs_organic_keywords`, omit the country argument entirely to retrieve worldwide totals.
- In `ahrefs_keyword_overview` and `ahrefs_keyword_overview_batch`, country is required (or defaults to `'us'` in single overview) because Keywords Explorer operates on distinct localized country databases (there is no unified worldwide keyword database).

### C. Logarithmic Authority Mathematics
- Domain Rating (DR) is logarithmic, similar to the Richter scale or decibels:
  - Moving from DR 20 to DR 30 requires an incremental gain in referring domains.
  - Moving from DR 70 to DR 80 requires an exponential leap in link equity.
- When computing comparative cohort benchmarks, arithmetic averages distort reality. The server computes `logarithmicAuthorityMean`:
  $$\text{Mean}_{\text{log}} = 10 \cdot \log_{10} \left( \frac{1}{N} \sum_{i=1}^N 10^{\text{DR}_i / 10} \right)$$
- Always interpret DR gaps logarithmically, not linearly.
