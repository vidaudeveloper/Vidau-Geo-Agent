# VidAU GEO Agent — AI Agent 安装提示词

把下面 **「中文版」** 或 **「English」** 整段复制，粘贴到 Cursor / Hermes / Claude Desktop 等 AI Agent 的对话里发送即可。

> 完整步骤见 **[docs/SETUP.md](./docs/SETUP.md)**（与 Creative Agent 同款三步：MCP → Skills → `/reset`）

---

## 中文版（复制以下全文）

```markdown
请按 VidAU GEO Agent 官方文档完成一键安装：

https://github.com/vidaudeveloper/Vidau-Geo-Agent/blob/main/docs/SETUP.md

按文档顺序执行：
1. MCP — 配置 `vidau-geo` → `https://geo.vidau.ai/mcp`（VidAU Agent / Hermes 无需 x-api-key）
2. Skills — 优先 `git clone` + `node scripts/install-skills.mjs --force`；不要用 raw.githubusercontent.com
3. 运行 `/reset` 使 MCP 与 Skills 生效

每步完成后简要汇报；需要我手动操作时先停下来等我确认。
```

---

## English (copy everything below)

```markdown
Please complete the VidAU GEO Agent one-click setup from the official doc:

https://github.com/vidaudeveloper/Vidau-Geo-Agent/blob/main/docs/SETUP.md

Follow in order:
1. MCP — configure `vidau-geo` → `https://geo.vidau.ai/mcp` (VidAU Agent / Hermes: no x-api-key)
2. Skills — prefer `git clone` + `node scripts/install-skills.mjs --force`; do not use raw.githubusercontent.com
3. Run `/reset` so MCP and Skills take effect

Report briefly after each step; pause when you need my manual action.
```

---

## 资源链接

| Resource | URL |
|----------|-----|
| Setup doc | [docs/SETUP.md](./docs/SETUP.md) |
| Skill manifest (CDN) | https://geo.vidau.ai/skills/manifest.json |
| MCP endpoint | https://geo.vidau.ai/mcp |
| Developer / API keys | https://geo.vidau.ai/developer |
| User guide | [SKILLS_GUIDE.md](./SKILLS_GUIDE.md) |
