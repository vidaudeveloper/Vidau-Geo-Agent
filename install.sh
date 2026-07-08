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
if hermes mcp list 2>/dev/null | grep -qiE 'geo\.vidau\.ai|VidAU GEO'; then
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
echo "1. Open https://geo.vidau.ai/developer and create an API Key"
echo "2. Connect MCP (pick one):"
echo ""
echo "   hermes mcp add \"VidAU GEO Agent\" \\"
echo "     --url https://geo.vidau.ai/mcp \\"
echo "     --header \"x-api-key=YOUR_KEY\""
echo ""
echo "   Or paste the YAML from the developer page into Hermes config."
echo ""

api_key=""
if [ -r /dev/tty ]; then
  printf "Paste API Key to configure now (Enter to skip): " > /dev/tty
  IFS= read -r api_key < /dev/tty || true
fi

if [ -n "${api_key}" ]; then
  hermes mcp add "VidAU GEO Agent" \
    --url "https://geo.vidau.ai/mcp" \
    --header "x-api-key=${api_key}"
  echo ""
  echo "MCP configured. Restart Hermes or /reload-mcp, then /reset."
  exit 0
fi

echo "Skipped MCP setup. Configure later at https://geo.vidau.ai/developer"
echo "Then: restart Hermes or /reload-mcp"
exit 1
