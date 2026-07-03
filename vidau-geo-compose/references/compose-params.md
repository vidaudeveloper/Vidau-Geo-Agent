# compose_article parameters

| Parameter | Values | Default |
|-----------|--------|---------|
| `language` | `auto`, `zh`, `en` | `auto` |
| `tone` | `professional`, `technical`, `plain`, `data`, `brand` | `professional` |
| `template_id` | `simple`, `vidau-blue`, `vidau-pink` | `simple` |
| `seo_keywords` | list of strings | `[]` → server auto-matches from brand keyword library |
| `topic` | string | required (or from suggest_topic / generate_topic) |
| `brand_id` | UUID | auto when one brand on account |

## When to override defaults

Only when the user mentions in natural language, or compose returns an error:

- "英文/English" → `language=en`
- "中文" → `language=zh`
- "口语/plain" → `tone=plain`
- "数据型" → `tone=data`
- "品牌视角" → `tone=brand`
- "蓝色模板/vidau-blue" → `template_id=vidau-blue`
- "用关键词 X, Y" → `seo_keywords=["X","Y"]`

## Prerequisites

Brand must have **brand words** and **SEO keywords** configured in GEO console → Brand → Keyword library.
Errors: `missing_brand_words`, `missing_seo_keywords` → direct user to configure there; never invent keywords.
