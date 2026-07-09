---
name: vidau-geo-publish
description: Publish compose_article output to WordPress or Shopify via VidAU MCP publish_compose.
version: 1.2.2
metadata:
  hermes:
    tags: [geo, vidau, publish, wordpress]
    category: marketing
---

# VidAU Publish GEO Article

## Step 0 — MCP check (only prompt when NOT connected)

**Check first:** Is **vidau-geo MCP** already connected and working?

| Result | What to do |
|--------|------------|
| **YES** — VidAU MCP tools are available and calls succeed (e.g. `list_brands`, `run_quick_audit`, `compose_article`) | **Skip this entire Step 0.** Do **not** mention MCP setup. Go straight to **When to Use / Procedure** below and run the skill normally. |
| **NO** — no VidAU tools in your tool list, or calls fail with **401** | **Stop.** Your **entire reply** = **only** the user message below (pick 中文 or English). Do **not** answer the original request. Do **not** invent audits, metrics, or articles. See `references/mcp-user-not-connected.md`. |

### 中文（仅 MCP 未连接时发给用户）

您已经安装了 VidAU Skill，但还**没有连接 vidau-geo MCP**，所以我暂时无法帮您完成这个请求。

请按下面 2 步操作（约 2 分钟）：
1. 打开 **https://geo.vidau.ai/developer** → 创建 **API Key** → 复制 **Hermes MCP 配置（YAML）**
2. 按照 **https://geo.vidau.ai/developer** 页面上的 Hermes 指引完成 MCP 连接并保存  
   （地址 `https://geo.vidau.ai/mcp`，请求头 `x-api-key`）

完成后请**再说一次**您的需求。

> Skill 是使用说明；**MCP 才是真正连接 VidAU 能力**。只装 Skill、不连 MCP **无法使用**。

### English (only when MCP is NOT connected)

You installed the VidAU Skill, but **vidau-geo MCP is not connected yet**, so I can't complete this request yet.

Please do these 2 steps (~2 minutes):
1. Open **https://geo.vidau.ai/developer** → create an **API key** → copy the **Hermes MCP config (YAML)**
2. Follow the Hermes setup guide on **https://geo.vidau.ai/developer** to connect MCP and save  
   (URL `https://geo.vidau.ai/mcp`, header `x-api-key`)

Then **ask again**.

> Skills are instructions only; **MCP is the live connection**. Skills without MCP **do not work**.
## When to Use

- User asks to **publish** or **post** an article after compose, or "发到 WordPress/Shopify".
- Requires a prior **`compose_article`** JSON response (full object).

## Procedure

1. **`list_connectors(brand_id)`** when multiple WordPress/Shopify sites exist.
2. **`publish_compose(compose=<full compose JSON>, connector_id=..., status=...)`**
   - Default **`status=draft`** unless user said "publish live" / "上线".
3. Success only when response has **`ok=true`** and **`postId`** / **`link`**.

## Pitfalls

- Saving to My Articles is **not** publishing — confirm with tool result.
- Do not claim success without `publish_compose` returning ok.
- MCP not connected → show Step 0 YAML (see Step 0).

## Verification

- User receives WordPress/Shopify post link from tool response.
