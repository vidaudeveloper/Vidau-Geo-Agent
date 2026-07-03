---
name: vidau-geo-mcp-setup
description: Detect missing VidAU GEO MCP and prompt the user to connect at geo.vidau.ai/developer — only when MCP is not already working.
version: 1.0.2
metadata:
  hermes:
    tags: [geo, vidau, setup, mcp]
    category: marketing
---

# VidAU GEO — Connect MCP First

## When to Use

- **Only when MCP is missing:** User tries audit, brand metrics, write article, publish, or automation but VidAU MCP tools are not available or return 401.
- User only installed Skills (`hermes skills install …`) without connecting VidAU GEO Agent MCP.

## Do NOT Use

- **MCP already connected and working** — skip this skill entirely. Do not mention setup. Run the user's requested VidAU skill instead.

## Step 0 — MCP gate

**Check first:** Can you call VidAU tools from MCP server `VidAU GEO Agent` / `geo.vidau.ai`?  
Examples: `list_brands`, `brand_overview`, `run_quick_audit`, `compose_article`.

| Result | Action |
|--------|--------|
| **YES** — tools work | **Do nothing.** No MCP prompt. Proceed with the user's actual request using the right VidAU skill. |
| **NO** — no tools or 401 | Reply with **only** the user message below (match 中文/English). Do **not** guess or fabricate data. |

### User message — 中文

您已经安装了 VidAU Skill，但还**没有连接 VidAU GEO Agent MCP**，所以我暂时无法帮您查询数据、写稿或做审计。

**请完成下面 2 步（约 2 分钟）：**

1. 打开 **https://geo.vidau.ai/developer** → 创建 **API Key** → 复制 **Hermes MCP 配置（YAML）**
2. 按照 **https://geo.vidau.ai/developer** 页面指引完成 MCP 连接（端点 `https://geo.vidau.ai/mcp`，请求头 `x-api-key`）

完成后请**再说一次**您的需求。

> Skill 是使用说明；**MCP 才是真正调用 VidAU 的连接**。只装 Skill、不连 MCP 无法工作。

### User message — English

You installed the VidAU Skill, but **VidAU GEO Agent MCP is not connected yet**, so I cannot fetch metrics, write articles, or run audits.

**Please complete these 2 steps (~2 minutes):**

1. Open **https://geo.vidau.ai/developer** → create **API key** → copy **Hermes MCP config (YAML)**
2. Follow **https://geo.vidau.ai/developer** to connect MCP (endpoint `https://geo.vidau.ai/mcp`, header `x-api-key`)

Then **ask again**.

> Skills are instructions; **MCP is the live connection**. Skills without MCP cannot work.

## Verification

- MCP missing → user got developer link and setup steps, not a fabricated answer.
- MCP working → user got their actual request handled; no setup nagging.
