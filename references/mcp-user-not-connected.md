# When MCP is not connected — say this to the user

**Only use this when VidAU MCP is NOT connected or returns 401.**  
If MCP is already working, **do not show this** — run the user's VidAU skill normally.

Use **only** this message (pick 中文 or English). Do not answer the original request. Do not invent data.

---

## 中文

您已经安装了 VidAU Skill，但还**没有连接 VidAU GEO Agent MCP**，所以我暂时无法帮您查询数据、写稿或做审计。

**请完成下面 2 步（约 2 分钟）：**

1. 打开 **https://geo.vidau.ai/developer**
   - 创建 **API Key**
   - 复制页面上的 **Hermes MCP 配置（YAML）**
2. 按照 **https://geo.vidau.ai/developer** 页面上的 Hermes 指引完成 MCP 连接并保存  
   - 地址：`https://geo.vidau.ai/mcp`  
   - 需要请求头：`x-api-key`（您的 Key）

完成后请**再说一次**刚才的需求，我就可以通过 MCP 为您执行。

> 说明：Skill 是使用说明；**MCP 才是真正调用 VidAU 能力的连接**。只装 Skill、不连 MCP 无法工作。

---

## English

You installed the VidAU Skill, but **VidAU GEO Agent MCP is not connected yet**, so I cannot fetch metrics, write articles, or run audits for you.

**Please complete these 2 steps (~2 minutes):**

1. Open **https://geo.vidau.ai/developer**
   - Create an **API key**
   - Copy the **Hermes MCP config (YAML)** from that page
2. Follow the Hermes setup guide on **https://geo.vidau.ai/developer** to connect MCP and save  
   - URL: `https://geo.vidau.ai/mcp`  
   - Header: `x-api-key` (your key)

Then **ask again** — I will run your request through MCP.

> Note: Skills are instructions only; **MCP is the live connection** to VidAU. Skills without MCP cannot work.

---

## If MCP is connected but calls fail

- **401 / invalid key** → same steps: new key at geo.vidau.ai/developer, update MCP connection per the developer guide  
- **402 / credits** → add credits at geo.vidau.ai
