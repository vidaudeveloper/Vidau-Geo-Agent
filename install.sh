#!/usr/bin/env bash
# Install all VidAU GEO Agent skills into Hermes (Creative-aligned flow).
# Usage: curl -fsSL https://geo.vidau.ai/skills/install.sh | bash
set -euo pipefail

REPO="${VIDAU_GEO_GITHUB_REPO:-https://github.com/vidaudeveloper/Vidau-Geo-Agent.git}"
TMP="${VIDAU_GEO_SKILL_DIR:-/tmp/vidau-geo-agent-skill}"

if [[ "${OS:-}" == "Windows_NT" || -n "${WINDIR:-}" ]]; then
  echo "On Windows Hermes Desktop, use PowerShell (not curl | bash):"
  echo "  irm https://geo.vidau.ai/skills/install.ps1 | iex"
  exit 1
fi

command -v node >/dev/null 2>&1 || {
  echo "Node.js is required. Install Node 18+ then re-run this script."
  echo "Or clone the repo and run: node scripts/install-skills.mjs --from-cdn --force"
  exit 1
}

command -v git >/dev/null 2>&1 || {
  echo "Git not found. Using CDN install (no clone)..."
  if [ ! -f "${TMP}/scripts/install-skills.mjs" ]; then
    mkdir -p "${TMP}/scripts"
    curl -fsSL "https://geo.vidau.ai/skills/scripts/install-skills.mjs" -o "${TMP}/scripts/install-skills.mjs"
  fi
  node "${TMP}/scripts/install-skills.mjs" --from-cdn --force
  INSTALL_OK=1
}

if [ "${INSTALL_OK:-0}" -ne 1 ]; then
  if [ ! -d "${TMP}/.git" ]; then
    rm -rf "${TMP}"
    git clone --depth 1 "${REPO}" "${TMP}"
  fi
  node "${TMP}/scripts/install-skills.mjs" --force
fi

echo ""
echo "Skills installed. Restart Hermes or run /reset to load them."
echo ""

# Skills are orchestration only — MCP is required to call VidAU APIs.
MCP_CONFIGURED=0
if command -v hermes >/dev/null 2>&1; then
  if hermes mcp list 2>/dev/null | grep -qiE 'geo\.vidau\.ai|vidau-geo|VidAU GEO'; then
    MCP_CONFIGURED=1
  fi
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
echo "Add to ~/.hermes/config.yaml:"
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
exit 1
