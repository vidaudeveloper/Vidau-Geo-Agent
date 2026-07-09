# When MCP is not connected — say this to the user

**Only use this when VidAU MCP is NOT connected or returns 401.**  
If MCP is already working, **do not show this** — run the user's VidAU skill normally.

Use **only** this message (pick 中文 or English). Do not answer the original request. Do not invent data.

---

## 中文

您已经安装了 VidAU Skill，但还**没有连接 vidau-geo MCP**，所以我暂时无法帮您查询数据、写稿或做审计。

**请完成下面步骤（约 2 分钟）：**

1. 在 VidAU Agent / Hermes 的 MCP 配置中添加：

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    enabled: true
    connect_timeout: 60
    timeout: 300
```

2. 保存后执行 `/reload-mcp`（或重启），再**说一次**刚才的需求。

> 说明：Skill 是使用说明；**MCP 才是真正调用 VidAU 能力的连接**。VidAU Agent 会自动带上登录用户身份，**不需要** `x-api-key`。

---

## English

You installed the VidAU Skill, but **vidau-geo MCP is not connected yet**, so I cannot fetch metrics, write articles, or run audits for you.

**Please complete these steps (~2 minutes):**

1. Add this to VidAU Agent / Hermes MCP config:

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    enabled: true
    connect_timeout: 60
    timeout: 300
```

2. Save, run `/reload-mcp` (or restart), then **ask again**.

> Note: Skills are instructions only; **MCP is the live connection**. VidAU Agent injects your logged-in user id — **no** `x-api-key` needed.

---

## If MCP is connected but calls fail

- **401 / auth failed** → confirm the `vidau-geo` block above; for Cursor/Claude use `x-api-key` from geo.vidau.ai/developer  
- **402 / credits** → add credits at geo.vidau.ai
