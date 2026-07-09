# VidAU GEO MCP prerequisites

Skills are **orchestration only**. They do not call GEO APIs by themselves.

## Required setup (both steps)

1. **Connect MCP** — add to `~/.hermes/config.yaml`:

   ```yaml
   mcp_servers:
     vidau-geo:
       url: https://geo.vidau.ai/mcp
       enabled: true
       connect_timeout: 60
       timeout: 300
   ```

2. **Install Skills**
   - macOS / Linux / Git Bash: `curl -fsSL https://geo.vidau.ai/skills/install.sh | bash`
   - Windows Hermes Desktop: `irm https://geo.vidau.ai/skills/install.ps1 | iex`

## When MCP is missing or broken

Stop and guide the user (do **not** fabricate audits, KPIs, or articles):

| Symptom | Tell the user |
|---------|----------------|
| VidAU tools not in tool list (`list_brands`, `brand_overview`, `compose_article`, `run_quick_audit`, …) | Connect MCP — Skills alone are not enough |
| 401 / auth failed | Confirm the `vidau-geo` block above, then `/reload-mcp` |
| 402 / insufficient credits | Add credits or upgrade at geo.vidau.ai |

After MCP is connected, retry the original request.
