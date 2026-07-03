#!/usr/bin/env bash
# Install all VidAU GEO Agent skills into Hermes.
# Usage: curl -fsSL https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.sh | bash
set -euo pipefail

REPO_BASE="${VIDAU_GEO_SKILLS_BASE:-https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main}"

command -v hermes >/dev/null 2>&1 || {
  echo "Hermes CLI not found. Install Hermes first: https://hermes-agent.nousresearch.com"
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

echo "Done. Restart Hermes or run /reset to load new skills."
echo ""
echo "Next: connect VidAU GEO Agent MCP at https://geo.vidau.ai/developer"
echo "  url: https://geo.vidau.ai/mcp"
echo "  header: x-api-key: geo_xxx"
