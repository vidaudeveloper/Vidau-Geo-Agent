#!/usr/bin/env bash
# Install all VidAU GEO Agent skills into Hermes.
# Usage: curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
set -euo pipefail

REPO_BASE="${VIDAU_GEO_SKILLS_BASE:-https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main}"

command -v hermes >/dev/null 2>&1 || {
  if [[ "${OS:-}" == "Windows_NT" || -n "${WINDIR:-}" ]]; then
    echo "On Windows Hermes Desktop, use PowerShell (not curl | bash):"
    echo "  irm https://geo.vidau.ai/skills/install.ps1 | iex"
    echo ""
    echo "If you use Git Bash, open a new terminal after installing Hermes so hermes is on PATH."
  else
    echo "Hermes CLI not found. Install Hermes first: https://hermes-agent.nousresearch.com"
  fi
  exit 1
}

SKILLS=(
  vidau-geo-mcp-setup
  vidau-geo-quick-audit
  vidau-geo-full-audit
  vidau-geo-brand-insights
  vidau-geo-compose
  vidau-geo-publish
  vidau-geo-write-draft
  vidau-geo-automation
)

echo "Installing ${#SKILLS[@]} VidAU GEO skills from ${REPO_BASE}..."

for skill in "${SKILLS[@]}"; do
  echo "→ ${skill}"
  hermes skills install "${REPO_BASE}/${skill}/SKILL.md"
done

echo ""
echo "Skills installed. Restart Hermes or run /reset to load them."
echo ""

# Skills are orchestration only — MCP is required to call VidAU APIs.
MCP_CONFIGURED=0
if hermes mcp list 2>/dev/null | grep -qiE 'geo\.vidau\.ai|vidau-geo|VidAU GEO'; then
  MCP_CONFIGURED=1
fi

if [ "$MCP_CONFIGURED" -eq 1 ]; then
  echo "MCP already connected (geo.vidau.ai). You are ready to use VidAU GEO."
  exit 0
fi

echo "════════════════════════════════════════════════════════"
echo "  MCP required — Skills are instructions only"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Skills do not connect to VidAU. Without MCP you cannot"
echo "query data, write articles, or run audits."
echo ""
echo "VidAU Agent / Hermes Desktop — add to ~/.hermes/config.yaml"
echo "(no x-api-key; desktop injects vidau_user_id):"
echo ""
echo "mcp_servers:"
echo "  vidau-geo:"
echo "    url: https://geo.vidau.ai/mcp"
echo "    enabled: true"
echo "    connect_timeout: 60"
echo "    timeout: 300"
echo ""
echo "Then: /reload-mcp or restart Hermes."
echo ""
echo "Cursor / Claude Desktop still need an API key from"
echo "https://geo.vidau.ai/developer (x-api-key header)."
echo ""
exit 1
