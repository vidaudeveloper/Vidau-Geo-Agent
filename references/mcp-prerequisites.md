# VidAU GEO MCP prerequisites

Skills are **orchestration only**. They do not call GEO APIs by themselves.

## Required setup (both steps)

1. **Connect MCP** — Hermes → Settings → MCP / Integrations → add remote server:
   - URL: `https://geo.vidau.ai/mcp`
   - Header: `x-api-key: <key from developer console>`
   - Create key at **https://geo.vidau.ai/developer**
2. **Install Skills** — `curl -fsSL https://geo.vidau.ai/skills/install.sh | bash`

## When MCP is missing or broken

Stop and guide the user (do **not** fabricate audits, KPIs, or articles):

| Symptom | Tell the user |
|---------|----------------|
| VidAU tools not in tool list (`list_brands`, `brand_overview`, `compose_article`, `run_quick_audit`, …) | Connect MCP at geo.vidau.ai/developer — Skills alone are not enough |
| 401 / missing x-api-key / invalid api key | Create or fix API key at geo.vidau.ai/developer, update MCP connection per the developer guide |
| 402 / insufficient credits | Add credits or upgrade at geo.vidau.ai |

After MCP is connected, retry the original request.
