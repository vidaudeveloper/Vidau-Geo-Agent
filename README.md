# VidAU GEO Agent Skills

**Generative Engine Optimization (GEO) skills for AI coding agents** — audit websites, monitor brand visibility in LLMs, compose GEO articles, and publish to WordPress / Shopify.

Works with [Hermes](https://hermes-agent.nousresearch.com), [Cursor](https://cursor.com), Claude Desktop, and any MCP-compatible client.

---

## 简介

VidAU GEO Agent Skills 是一套面向 AI Agent 的 **GEO（生成式引擎优化）** 技能包。安装后，你可以在对话里用自然语言完成：

- 对任意网站做 **60 秒 GEO 快照** 或 **完整 GEO 审计**
- 查看已跟踪品牌在 ChatGPT、Perplexity 等大模型中的 **可见度、引用率、SOV、情感分**
- **撰写 GEO 文章**（含 meta、schema、质检）
- **发布到 WordPress / Shopify**
- 配置 **内容自动化** 流水线（选题 → 写稿 → 质检 → 发布）

> **重要：** Skill 是使用说明；**MCP 才是真正连接 VidAU 能力的通道**。只装 Skill、不连 MCP 无法调用 API。

---

## Quick Start

### Step 1 — Connect MCP (required)

Create an API key at **[geo.vidau.ai/developer](https://geo.vidau.ai/developer)**, then add the VidAU GEO Agent MCP server:

**Hermes** (`~/.hermes/config.yaml`):

```yaml
mcp_servers:
  VidAU GEO Agent:
    url: https://geo.vidau.ai/mcp
    headers:
      x-api-key: geo_xxx
```

**Cursor / Claude Desktop**:

```json
{
  "mcpServers": {
    "VidAU GEO Agent": {
      "url": "https://geo.vidau.ai/mcp",
      "headers": {
        "x-api-key": "geo_xxx"
      }
    }
  }
}
```

Save and restart your agent (Hermes: `/reload-mcp` or restart).

### Step 2 — Install Skills

**One command (Hermes):**

```bash
curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
```

**Or install from geo.vidau.ai (same pack, production CDN):**

```bash
curl -fsSL https://geo.vidau.ai/skills/install.sh | bash
```

**Manual install (any client that supports remote SKILL.md URLs):**

```bash
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-quick-audit/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-full-audit/SKILL.md
# ... see manifest.json for all skill URLs
```

**Offline:** clone this repo and copy skill folders to `~/.hermes/skills/`, or download the zip from [geo.vidau.ai/skills/vidau-geo-skills.zip](https://geo.vidau.ai/skills/vidau-geo-skills.zip).

---

## 快速开始（中文）

### 第 1 步 — 连接 MCP（必须）

1. 打开 **[geo.vidau.ai/developer](https://geo.vidau.ai/developer)**
2. 创建 **API Key**
3. 按页面指引把 MCP 配到 Hermes / Cursor / Claude Desktop  
   - 地址：`https://geo.vidau.ai/mcp`  
   - 请求头：`x-api-key: geo_xxx`

### 第 2 步 — 安装 Skills

```bash
curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
```

安装完成后重启 Agent，即可在对话中使用。

---

## Skill Pack

| Skill | 用途 | Example prompt |
|-------|------|----------------|
| `vidau-geo-mcp-setup` | MCP 未连接时引导用户完成配置 | （自动触发） |
| `vidau-geo-quick-audit` | 60 秒 GEO 快照 → HTML 报告 | *Run a 60-second GEO snapshot for https://example.com* |
| `vidau-geo-full-audit` | 完整 GEO 审计 → HTML 报告 + 行动建议 | *Run a full GEO audit for https://example.com* |
| `vidau-geo-brand-insights` | 已跟踪品牌的可见度 / 引用率 / SOV / 情感 | *How is our brand doing this week?* |
| `vidau-geo-compose` | 撰写 GEO 文章（meta + schema + 质检） | *Write a GEO competitor comparison article* |
| `vidau-geo-publish` | 发布 compose 结果到 WordPress / Shopify | *Publish the article to WordPress as draft* |
| `vidau-geo-write-draft` | 仅 Markdown 草稿（不含 meta/schema） | *Draft a short markdown outline only* |
| `vidau-geo-automation` | 内容自动化（一次性或定时） | *Run the full automation pipeline now* |

Manifest: [`manifest.json`](manifest.json)

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  AI Agent (Hermes / Cursor / Claude Desktop)            │
│  ┌──────────────┐    ┌──────────────────────────────┐   │
│  │ Skills       │    │ MCP: VidAU GEO Agent         │   │
│  │ (this repo)  │───▶│ https://geo.vidau.ai/mcp     │   │
│  │ orchestration│    │ x-api-key: geo_xxx           │   │
│  └──────────────┘    └──────────────┬───────────────┘   │
└─────────────────────────────────────┼───────────────────┘
                                      │
                                      ▼
                         ┌────────────────────────┐
                         │  VidAU GEO Platform    │
                         │  geo.vidau.ai          │
                         │  · Audits & reports    │
                         │  · Brand monitoring    │
                         │  · Content compose     │
                         │  · WordPress/Shopify   │
                         └────────────────────────┘
```

- **Skills** = instructions for the agent (what to call, when, how to reply)
- **MCP** = live API connection (33 tools: audits, brands, compose, publish, automation, …)
- Skill install is **public** (no API key). Calling MCP tools requires a valid `x-api-key` with credits.

---

## Repository Structure

```
Vidau-Geo-Agent/
├── README.md
├── manifest.json              # Skill pack metadata & install URLs
├── install.sh                 # One-command installer for Hermes
├── references/                # Shared reference docs
│   ├── mcp-prerequisites.md
│   └── mcp-user-not-connected.md
├── vidau-geo-mcp-setup/
├── vidau-geo-quick-audit/
├── vidau-geo-full-audit/
├── vidau-geo-brand-insights/
├── vidau-geo-compose/
│   └── references/compose-params.md
├── vidau-geo-publish/
├── vidau-geo-write-draft/
└── vidau-geo-automation/
```

Each skill folder contains a `SKILL.md` with YAML frontmatter (name, description, version, Hermes tags).

---

## MCP Tools (33)

Skills orchestrate these MCP tools exposed at `https://geo.vidau.ai/mcp`:

| Category | Tools |
|----------|-------|
| **Audits** | `run_quick_audit`, `run_geo_audit` |
| **Brand monitoring** | `list_brands`, `brand_overview`, `citations`, `opportunities`, `leaderboard`, `list_responses` |
| **Content** | `compose_article`, `write_article`, `suggest_topic`, `generate_topic`, `score_article`, `optimize_article`, `list_article_templates` |
| **Publish** | `list_connectors`, `publish_compose`, `publish_wordpress`, `publish_shopify` |
| **Automation** | `run_content_automation`, `wait_for_content_automation_run`, `update_content_automation_settings`, `cancel_content_automation_run` |
| **Analytics** | `keyword_volume`, `seo_traffic`, `query_fanout`, `generate_fanout` |

Full tool ↔ API mapping: [geo.vidau.ai developer docs](https://geo.vidau.ai/developer).

---

## Requirements

| Item | Required |
|------|----------|
| VidAU GEO account + API key | Yes (for MCP calls) |
| Hermes CLI or MCP-compatible agent | Yes |
| Skill install | Public, no key needed |
| Credits | Audits, compose, and automation consume credits |

---

## Usage Tips

- **One brand on account** → agent picks it silently; no need to ask.
- **Multiple brands** → agent asks once using **site names**, never UUIDs.
- **Default article path** → `vidau-geo-compose` (full pipeline). Use `vidau-geo-write-draft` only when user wants markdown-only.
- **Publish default** → draft unless user says "publish live" / "上线".
- **MCP not connected** → agent shows setup guide from `vidau-geo-mcp-setup`; no fabricated data.

---

## Related Links

| Resource | URL |
|----------|-----|
| GEO Console | [geo.vidau.ai](https://geo.vidau.ai) |
| Developer / MCP setup | [geo.vidau.ai/developer](https://geo.vidau.ai/developer) |
| Production skill CDN | [geo.vidau.ai/skills](https://geo.vidau.ai/skills/manifest.json) |
| Hermes Agent | [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com) |

---

## License

Copyright © VidAU. Skills in this repository are provided for use with the VidAU GEO platform.

---

<p align="center">
  <strong>GEO-first. AI-native.</strong><br/>
  Optimize for where search traffic is going — not where it was.
</p>
