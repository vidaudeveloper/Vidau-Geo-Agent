# VidAU GEO Agent — One-Click Setup

Please complete the full GEO Agent setup in the following order:

1. **MCP**: Check whether `vidau-geo` is already connected and working. If not, configure the MCP server `vidau-geo` to point to `https://geo.vidau.ai/mcp`. Reload MCP and verify the connection is healthy.

   **VidAU Agent / Hermes Desktop** (`~/.hermes/config.yaml`) — no `x-api-key`; desktop injects `vidau_user_id`:

   ```yaml
   mcp_servers:
     vidau-geo:
       url: https://geo.vidau.ai/mcp
       enabled: true
       connect_timeout: 60
       timeout: 300
   ```

   **Cursor / Claude Desktop** — create an API key at [geo.vidau.ai/developer](https://geo.vidau.ai/developer), then use `x-api-key` in MCP headers.

2. **Skills**: Install **all** Skills from `https://github.com/vidaudeveloper/Vidau-Geo-Agent` (branch `main`). **Do not** use `raw.githubusercontent.com` URLs — they often return HTTP 429. The skill list is defined in `manifest.json` — never hardcode skill names.

   **Preferred (one shallow clone, zero raw CDN requests):**

   ```bash
   git clone --depth 1 https://github.com/vidaudeveloper/Vidau-Geo-Agent.git /tmp/vidau-geo-agent-skill
   node /tmp/vidau-geo-agent-skill/scripts/install-skills.mjs --force
   ```

   The script reads local `manifest.json`, then copies every `skills[].path` (including `references/`) into `~/.hermes/skills/vidau-geo/`.

   **One-liner (macOS / Linux / Git Bash):**

   ```bash
   curl -fsSL https://geo.vidau.ai/skills/install.sh | bash
   ```

   **Windows Hermes Desktop (PowerShell):**

   ```powershell
   irm https://geo.vidau.ai/skills/install.ps1 | iex
   ```

   **Fallback A (no local copy, but git available):**

   ```bash
   git clone --depth 1 https://github.com/vidaudeveloper/Vidau-Geo-Agent.git /tmp/vidau-geo-agent-skill
   node /tmp/vidau-geo-agent-skill/scripts/install-skills.mjs --remote --force
   ```

   **Fallback B (no git):** fetch `manifest.json` via GitHub Contents API (not raw CDN), parse every `skills[].path` in manifest order, and for each path run:

   ```bash
   hermes skills install vidaudeveloper/Vidau-Geo-Agent/<path> --force --yes --category vidau-geo
   ```

   Manifest URL: `https://api.github.com/repos/vidaudeveloper/Vidau-Geo-Agent/contents/manifest.json?ref=main` (decode the `content` field from base64).

   Or run the install script with API-fetched manifest (download script via the same Contents API if needed):

   ```bash
   node install-skills.mjs --from-github --remote --force
   ```

   **Fallback C (production CDN, no git):**

   ```bash
   node install-skills.mjs --from-cdn --force
   ```

   After installation, verify that the installed skill list matches every `skills[].id` in `manifest.json`.

3. **Apply changes**: Run `/reset` (or `/new`) to restart the session so MCP and Skills all take effect.
