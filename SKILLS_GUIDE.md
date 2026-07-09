# VidAU GEO Agent — Skills 使用指南 / Skills User Guide

面向 **Cursor、Hermes、Claude Desktop** 等 AI Agent 用户：用自然语言完成 GEO 审计、品牌监测、写稿与发布。

> **Skill = 使用说明 · MCP = 实时 API 连接**  
> Skills alone cannot call VidAU — MCP must be connected at [geo.vidau.ai/developer](https://geo.vidau.ai/developer).

| Resource | URL |
|----------|-----|
| GitHub skill pack | https://github.com/vidaudeveloper/Vidau-Geo-Agent |
| Skill manifest (CDN) | https://geo.vidau.ai/skills/manifest.json |
| MCP endpoint | https://geo.vidau.ai/mcp |
| Help Center (中文) | https://geo.vidau.ai/zh/help/agent-skills |
| Help Center (English) | https://geo.vidau.ai/en/help/agent-skills |
| Auto-install prompt | [INSTALL_PROMPT.md](./INSTALL_PROMPT.md) |

---

## 中文

### Skills 与 MCP

```
你（自然语言） → Skill（工作流） → MCP 工具（API） → geo.vidau.ai
```

| 层级 | 作用 |
|------|------|
| **Skills** | 告诉 Agent **怎么做**（8 个 Skill，见 manifest） |
| **MCP** | **真正执行**（34 个工具：审计、写稿、发布…） |

### 安装顺序

完整一键安装提示词见 **[docs/SETUP.md](./docs/SETUP.md)**（MCP → Skills → `/reset`）。

1. **连 MCP** — 写入下方 `vidau-geo` YAML
2. **装 Skills**
   - **推荐：** `git clone` + `node scripts/install-skills.mjs --force`（不要用 raw.githubusercontent.com）
   - **macOS / Linux / Git Bash：** `curl -fsSL https://geo.vidau.ai/skills/install.sh | bash`
   - **Windows Hermes Desktop（PowerShell）：** `irm https://geo.vidau.ai/skills/install.ps1 | iex`
3. **运行 `/reset`** — 使 MCP 与 Skills 生效

### 8 个 Skill · 示例说法

| 目标 | 怎么说 |
|------|--------|
| 60 秒 GEO 快照 | *给 https://example.com 做 60 秒 GEO 快照，把 HTML 报告链接给我。* |
| 完整 GEO 审计 | *给 https://example.com 做一次完整 GEO 审计。* |
| 品牌监测 KPI | *我们品牌这周可见度、引用率、SOV、情感分怎么样？* |
| 写 GEO 文章 | *帮我们写一篇 GEO 竞品对比文章。* |
| 发布 WordPress | *把刚才写的文章以草稿形式发布到 WordPress。* |
| 仅 Markdown 草稿 | *只要 Markdown，不要 meta 和 schema。* |
| 内容自动化 | *走完整自动化：选题、写稿、质检并发布。* |

**写稿默认路径：** `vidau-geo-compose`（meta + schema + SEO 关键词 + 可选配图 + 质检）。

**Compose 编排：** 选题 → `suggest_seo_keywords` → `compose_article` → 控制台预览 →（可选）`publish_compose`

### 技巧与排错

- 单品牌账号 → Agent 自动选中；多品牌 → 用站点名确认
- 发布默认 **草稿**；审计/写稿消耗积分
- MCP 未连接 → 自动显示 `vidau-geo-mcp-setup` 引导，**不会编造数据**
- `missing_seo_keywords` → 在 Brand 关键词库配置
- 配图跳过 → 连接 WordPress，或 `image_source=none`

---

## English

### Skills vs MCP

```
You (natural language) → Skill (workflow) → MCP tools (API) → geo.vidau.ai
```

| Layer | Role |
|-------|------|
| **Skills** | Tell the agent **what to do** (8 skills in manifest) |
| **MCP** | **Execute** (34 tools: audits, compose, publish, …) |

### Setup order

See **[docs/SETUP.md](./docs/SETUP.md)** for the full one-click prompt (MCP → Skills → `/reset`).

1. **Connect MCP** — add the `vidau-geo` YAML below
2. **Install Skills** — prefer `git clone` + `node scripts/install-skills.mjs --force` (avoid raw.githubusercontent.com)
   - **macOS / Linux / Git Bash:** `curl -fsSL https://geo.vidau.ai/skills/install.sh | bash`
   - **Windows Hermes Desktop (PowerShell):** `irm https://geo.vidau.ai/skills/install.ps1 | iex`
3. **Run `/reset`** — then talk naturally; Skills orchestrate MCP

### 8 skills · example prompts

| Goal | Example |
|------|---------|
| 60s GEO snapshot | *Run a 60-second GEO snapshot for https://example.com and give me the HTML report.* |
| Full GEO audit | *Run a full GEO audit for https://example.com.* |
| Brand KPIs | *How is our brand doing — visibility, citations, SOV, sentiment?* |
| Write GEO article | *Write a GEO competitor comparison article for our site.* |
| Publish WordPress | *Publish the article you just wrote to WordPress as a draft.* |
| Markdown only | *Draft markdown only — no meta or schema.* |
| Content automation | *Run the full pipeline: topic → compose → quality → publish.* |

**Default write path:** `vidau-geo-compose` (meta, schema, SEO keywords, optional hero images, quality gate).

**Compose flow:** topic → `suggest_seo_keywords` → `compose_article` → preview in console → (optional) `publish_compose`

### Tips & troubleshooting

- One brand → auto-selected; multiple brands → confirm by site name
- Publish defaults to **draft**; audits and compose use credits
- MCP missing → `vidau-geo-mcp-setup` guides setup; **no fabricated data**
- `missing_seo_keywords` → configure keyword library in Brand settings
- Images skipped → connect WordPress, or use `image_source=none`

---

## MCP config

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    enabled: true
    connect_timeout: 60
    timeout: 300
```

---

<p align="center"><strong>GEO-first. AI-native.</strong></p>
