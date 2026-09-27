# Pre-Flight Parameter Validation & Sanitization

## 1. Domain Sanitization Protocol

Ahrefs domain-level tools (`site_overview`, `organic_keywords`, `top_pages`, `backlinks`, `content_gap`, `link_intersect`, `benchmark`) operate exclusively on **bare hostnames**. Passing arbitrary URLs or malformed strings causes immediate validation rejections or upstream failures.

### Sanitization Pipeline

```
Raw User Input: "https://www.example.com/blog/seo-tips?ref=twitter#header"
                             │
                             ▼ Strip Protocol & Fragments
"www.example.com/blog/seo-tips"
                             │
                             ▼ Strip Path & Query
"www.example.com"
                             │
                             ▼ Strip "www." (Optional based on target)
"example.com" (Bare Hostname)
```

### Validation Rules
1. **No URL Schemes**: Reject or strip `http://` and `https://`.
2. **No Paths or Queries**: Paths (`/blog`), query parameters (`?q=seo`), and hash anchors (`#top`) are prohibited.
3. **Preserve Subdomains**: Do not strip meaningful subdomains like `app.example.com`, `shop.example.com`, or `blog.example.com`.
4. **LDH Compliance**: Hostname labels must consist solely of Letters, Digits, and Hyphens (LDH), separated by dots. Total length must not exceed 253 characters.

---

## 2. Country Code Enforcement

- **Format**: Strictly 2-letter lowercase ISO 3166-1 alpha-2 code (`^[a-z]{2}$`).
- **Accepted Examples**: `"us"`, `"tr"`, `"de"`, `"gb"`, `"fr"`, `"es"`, `"nl"`.
- **Prohibited Inputs**:
  - Full names: `"United States"` or `"Turkey"`.
  - 3-letter codes: `"USA"` or `"TUR"`.
  - Uppercase strings: `"US"` (must be lowercased to `"us"`).
- **Omission Semantics**:
  - In `site_overview` and `top_pages`: Omitting country defaults to **worldwide** totals.
  - In `keyword_overview` and `content_gap`: Omitting country defaults to **US** (`"us"`).

---

## 3. Tabular Numeric Bounds & Clamping

| Parameter | Tool Scope | Permitted Range | Default Value | Enforcement |
|:---|:---|:---:|:---:|:---|
| `limit` | Tabular tools | 1 – 1,000 | 50 or 100 | Values $>1000$ are clamped to $1000$. |
| `minVolume` | Filtering | $\ge 0$ | `undefined` | Must be a non-negative integer. |
| `maxKd` | Filtering | 0 – 100 | `undefined` | Out-of-bounds numbers ($<0$ or $>100$) rejected. |
| `minTraffic` | `top_pages` | $\ge 0$ | `undefined` | Non-negative integer. |
| `offset` | `query_artifact` | $\ge 0$ | 0 | 0-based row cursor. |
| `limit` | `query_artifact` | 1 – 200 | 50 | Clamped to max 200 per page. |
