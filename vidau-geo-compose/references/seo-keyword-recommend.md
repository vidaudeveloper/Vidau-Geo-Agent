# SEO keyword recommendation (LLM)

Used by `POST /api/content/suggest-seo-keywords` and the Content Creation UI **AI recommend** action.

## Inputs

| Signal | Source |
|--------|--------|
| Article topic | User input |
| Brand words + SEO library | Brand profile |
| Hot prompts / demand | Content opportunities (gap score, volume tier, visibility) |
| Competitors | Brand profile competitors |
| GEO audit | Latest audit excerpt for the brand |

## Output

3–6 keyword phrases:

- **1 primary** — best H1 / title intent match
- **2–5 secondary** — semantic support, long-tail, comparison, FAQ variants

New phrases may be added to the brand SEO keyword library automatically when the LLM proposes terms not yet stored.

## Fallback

If LLM is unavailable, falls back to rule-based library matching (`match_relevant_seo_keywords`).
