# VidAU GEO Agent — AI Agent 安装提示词

把下面 **「中文版」** 或 **「English」** 整段复制，粘贴到 Cursor / Hermes / Claude Desktop 等 AI Agent 的对话里发送即可。Agent 会按步骤完成 MCP 连接与 Skills 安装。

> 仓库：<https://github.com/vidaudeveloper/Vidau-Geo-Agent>  
> Skill 清单：<https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/manifest.json>

---

## 中文版（复制以下全文）

```markdown
请帮我安装 VidAU GEO Agent Skills，让我可以在对话里做 GEO 审计、品牌监测、写稿和发布。

## 资源

- GitHub 仓库：https://github.com/vidaudeveloper/Vidau-Geo-Agent
- Skill 清单（manifest）：https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/manifest.json
- 一键安装脚本（Hermes macOS/Linux）：https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh
- 一键安装脚本（Hermes Windows）：https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.ps1
- MCP 端点：https://geo.vidau.ai/mcp（请求头 `x-api-key`）
- 开发者控制台（创建 API Key）：https://geo.vidau.ai/developer

## 你要做的事

按顺序执行，每步完成后简要汇报；遇到需要我手动操作的步骤（如创建 API Key），先停下来等我提供。

### 1. 确认运行环境

判断我当前用的是哪种 Agent 客户端：

- **Hermes**（有 `hermes` CLI 或 `~/.hermes/config.yaml`）
- **Cursor**（有 `.cursor/` 或 Cursor MCP 配置）
- **Claude Desktop**（有 `claude_desktop_config.json`）
- **其他 MCP 兼容客户端**

根据环境选择对应的 MCP 与 Skills 安装方式。

### 2. 连接 vidau-geo MCP（必须）

如果还没有 API Key，请提示我：

1. 打开 https://geo.vidau.ai/developer
2. 创建 API Key（格式 `geo_xxx`）
3. 把 Key 发给你（或自行写入配置文件，需我确认）

然后配置 MCP：

**Hermes** — 编辑 `~/.hermes/config.yaml`：

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    headers:
      x-api-key: <我的 API Key>
```

**Cursor** — 在项目或用户 MCP 配置中添加：

```json
{
  "mcpServers": {
    "vidau-geo": {
      "url": "https://geo.vidau.ai/mcp",
      "headers": {
        "x-api-key": "<我的 API Key>"
      }
    }
  }
}
```

**Claude Desktop** — 编辑 `%APPDATA%\Claude\claude_desktop_config.json`（macOS：`~/Library/Application Support/Claude/`）：

```json
{
  "mcpServers": {
    "vidau-geo": {
      "url": "https://geo.vidau.ai/mcp",
      "headers": {
        "x-api-key": "<我的 API Key>"
      }
    }
  }
}
```

保存后重启 Agent，或 Hermes 执行 `/reload-mcp`。

### 3. 安装全部 8 个 Skills

Base URL：`https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main`

**Hermes（macOS/Linux/Git Bash）：**

```bash
curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
```

**Hermes Windows Desktop（PowerShell）：**

```powershell
irm https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.ps1 | iex
```

或逐个安装：

```bash
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-mcp-setup/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-quick-audit/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-full-audit/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-brand-insights/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-compose/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-publish/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-write-draft/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-automation/SKILL.md
```

**Cursor** — 下载到 `~/.cursor/skills/<skill-id>/SKILL.md`（每个 skill 一个目录）：

| Skill ID | 安装 URL |
|----------|----------|
| vidau-geo-mcp-setup | …/vidau-geo-mcp-setup/SKILL.md |
| vidau-geo-quick-audit | …/vidau-geo-quick-audit/SKILL.md |
| vidau-geo-full-audit | …/vidau-geo-full-audit/SKILL.md |
| vidau-geo-brand-insights | …/vidau-geo-brand-insights/SKILL.md |
| vidau-geo-compose | …/vidau-geo-compose/SKILL.md |
| vidau-geo-publish | …/vidau-geo-publish/SKILL.md |
| vidau-geo-write-draft | …/vidau-geo-write-draft/SKILL.md |
| vidau-geo-automation | …/vidau-geo-automation/SKILL.md |

`vidau-geo-compose` 还需安装 `references/compose-params.md` 到同目录下的 `references/`。

共享参考文件安装到 `~/.cursor/skills/references/`（或各 skill 可访问的路径）：

- …/references/mcp-prerequisites.md
- …/references/mcp-user-not-connected.md

**离线备选：** `git clone https://github.com/vidaudeveloper/Vidau-Geo-Agent.git`，把各 `vidau-geo-*/` 目录复制到对应 skills 目录。

安装完成后重启 Agent（Hermes 可 `/reset`）。

### 4. 验证

1. MCP：调用 `list_brands`（或任意 VidAU MCP tool），确认不返回 401。
2. Skills：确认 8 个 skill 均已安装且可被 Agent 发现。
3. 若 MCP 未通，不要假装安装成功或编造审计结果。

### 5. 安装完成 — 告诉我的示例用法

| 场景 | 示例说法 |
|------|----------|
| 60 秒 GEO 快照 | 给 https://example.com 做一个 60 秒 GEO 快照 |
| 完整 GEO 审计 | 给 https://example.com 做一次完整 GEO 审计 |
| 品牌监测 | 我们品牌这周在大模型里的可见度、引用率、SOV 怎么样？ |
| 写 GEO 文章 | 帮我们写一篇 GEO 竞品对比文章 |
| 发布 | 把刚才写的文章以草稿形式发布到 WordPress |
| 内容自动化 | 现在走完整自动化：选题、写稿、质检并发布 |

请现在开始安装，并在需要 API Key 时问我。
```

---

## English (copy full block below)

```markdown
Please install VidAU GEO Agent Skills so I can run GEO audits, brand monitoring, article compose, and publishing from chat.

## Resources

- GitHub repo: https://github.com/vidaudeveloper/Vidau-Geo-Agent
- Skill manifest: https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/manifest.json
- One-shot installer (Hermes macOS/Linux): https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh
- One-shot installer (Hermes Windows): https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.ps1
- MCP endpoint: https://geo.vidau.ai/mcp (header `x-api-key`)
- Developer console (API key): https://geo.vidau.ai/developer

## Your tasks

Execute in order and report briefly after each step. Stop and ask me when manual action is required (e.g. creating an API key).

### 1. Detect client environment

Identify which agent client I use:

- **Hermes** (`hermes` CLI or `~/.hermes/config.yaml`)
- **Cursor** (`.cursor/` or Cursor MCP settings)
- **Claude Desktop** (`claude_desktop_config.json`)
- **Other MCP-compatible client**

Pick the matching MCP and Skills install path.

### 2. Connect vidau-geo MCP (required)

If I have no API key yet, tell me to:

1. Open https://geo.vidau.ai/developer
2. Create an API key (`geo_xxx`)
3. Send you the key (or confirm before you write config files)

Then configure MCP:

**Hermes** — `~/.hermes/config.yaml`:

```yaml
mcp_servers:
  vidau-geo:
    url: https://geo.vidau.ai/mcp
    headers:
      x-api-key: <MY_API_KEY>
```

**Cursor** — user or project MCP config:

```json
{
  "mcpServers": {
    "vidau-geo": {
      "url": "https://geo.vidau.ai/mcp",
      "headers": {
        "x-api-key": "<MY_API_KEY>"
      }
    }
  }
}
```

**Claude Desktop** — `%APPDATA%\Claude\claude_desktop_config.json` (macOS: `~/Library/Application Support/Claude/`):

```json
{
  "mcpServers": {
    "vidau-geo": {
      "url": "https://geo.vidau.ai/mcp",
      "headers": {
        "x-api-key": "<MY_API_KEY>"
      }
    }
  }
}
```

Save and restart the agent (Hermes: `/reload-mcp`).

### 3. Install all 8 skills

Base URL: `https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main`

**Hermes (macOS/Linux/Git Bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
```

**Hermes Windows Desktop (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.ps1 | iex
```

Or install each skill:

```bash
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-mcp-setup/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-quick-audit/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-full-audit/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-brand-insights/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-compose/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-publish/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-write-draft/SKILL.md
hermes skills install https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/vidau-geo-automation/SKILL.md
```

**Cursor** — download each to `~/.cursor/skills/<skill-id>/SKILL.md`:

| Skill ID | Install URL suffix |
|----------|-------------------|
| vidau-geo-mcp-setup | /vidau-geo-mcp-setup/SKILL.md |
| vidau-geo-quick-audit | /vidau-geo-quick-audit/SKILL.md |
| vidau-geo-full-audit | /vidau-geo-full-audit/SKILL.md |
| vidau-geo-brand-insights | /vidau-geo-brand-insights/SKILL.md |
| vidau-geo-compose | /vidau-geo-compose/SKILL.md (+ references/compose-params.md) |
| vidau-geo-publish | /vidau-geo-publish/SKILL.md |
| vidau-geo-write-draft | /vidau-geo-write-draft/SKILL.md |
| vidau-geo-automation | /vidau-geo-automation/SKILL.md |

Shared references: `references/mcp-prerequisites.md`, `references/mcp-user-not-connected.md`

**Offline:** `git clone https://github.com/vidaudeveloper/Vidau-Geo-Agent.git` and copy skill folders into the skills directory.

Restart the agent when done (Hermes: `/reset`).

### 4. Verify

1. MCP: call `list_brands` (or any VidAU tool) — must not return 401.
2. Skills: all 8 skills installed and discoverable.
3. If MCP is down, do not claim success or fabricate audit data.

### 5. Example prompts after install

| Use case | Example |
|----------|---------|
| 60s GEO snapshot | Run a 60-second GEO snapshot for https://example.com |
| Full GEO audit | Run a full GEO audit for https://example.com |
| Brand monitoring | How is our brand doing this week — visibility, citations, SOV? |
| Write GEO article | Write a GEO competitor comparison article for our site |
| Publish | Publish the article to WordPress as a draft |
| Automation | Run the full automation pipeline now |

Start the installation now and ask me for the API key when needed.
```

---

## 说明

| 项目 | 内容 |
|------|------|
| Skills 数量 | 8 个（见 `manifest.json`） |
| MCP 与 Skills 关系 | Skills 是编排说明；MCP 是 API 连接。**两者都必须安装** |
| Skill 安装 | 公开，无需 API Key |
| MCP 调用 | 需要有效 `x-api-key` 和账户积分 |
| 生产 CDN 备选 | `curl -fsSL https://geo.vidau.ai/skills/install.sh \| bash` |
