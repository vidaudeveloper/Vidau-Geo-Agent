# When MCP is not connected — say this to the user

**Only use this when VidAU MCP is NOT connected or returns 401.**  
If MCP is already working, **do not show this** — run the user's VidAU skill normally.

Use **only** this message (pick 中文 or English). Do not answer the original request. Do not invent data.

---

## 中文

您已经安装了 VidAU Skill，但还**没有连接 vidau-geo MCP**，所以我暂时无法帮您查询数据、写稿或做审计。

**请完成下面步骤（约 2 分钟）：**

1. 在 MCP 配置中添加：

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    enabled: true
    connect_timeout: 60
    timeout: 300
```

2. 保存后执行 `/reload-mcp`（或重启），再**说一次**刚才的需求。

---

## English

You installed the VidAU Skill, but **vidau-geo MCP is not connected yet**, so I cannot fetch metrics, write articles, or run audits for you.

**Please complete these steps (~2 minutes):**

1. Add this to MCP config:

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    enabled: true
    connect_timeout: 60
    timeout: 300
```

2. Save, run `/reload-mcp` (or restart), then **ask again**.

---

## If MCP is connected but calls fail

- **401 / auth failed** → confirm the `vidau-geo` block above, then `/reload-mcp`
- **402 / credits** → add credits at geo.vidau.ai
