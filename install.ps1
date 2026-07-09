#Requires -Version 5.1
# Install all VidAU GEO Agent skills into Hermes (Creative-aligned flow).
# Usage:
#   irm https://geo.vidau.ai/skills/install.ps1 | iex

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Repo = if ($env:VIDAU_GEO_GITHUB_REPO) {
    $env:VIDAU_GEO_GITHUB_REPO
} else {
    'https://github.com/vidaudeveloper/Vidau-Geo-Agent.git'
}

$Tmp = if ($env:VIDAU_GEO_SKILL_DIR) {
    $env:VIDAU_GEO_SKILL_DIR
} else {
    Join-Path $env:TEMP 'vidau-geo-agent-skill'
}

function Get-HermesHome {
    if ($env:HERMES_HOME) { return $env:HERMES_HOME }
    return Join-Path $env:LOCALAPPDATA 'hermes'
}

function Resolve-HermesCli {
    $cmd = Get-Command hermes -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $candidate = Join-Path (Get-HermesHome) 'hermes-agent\venv\Scripts\hermes.exe'
    if (Test-Path -LiteralPath $candidate) { return $candidate }
    return $null
}

function Test-VidauMcpConfigured {
    $configPath = Join-Path (Get-HermesHome) 'config.yaml'
    $cli = Resolve-HermesCli

    if ($cli) {
        try {
            $out = & $cli mcp list 2>$null | Out-String
            if ($out -match 'geo\.vidau\.ai|vidau-geo|VidAU GEO') { return $true }
        } catch {
            # fall through to config.yaml check
        }
    }

    if (Test-Path -LiteralPath $configPath) {
        $content = Get-Content -LiteralPath $configPath -Raw -ErrorAction SilentlyContinue
        if ($content -match 'geo\.vidau\.ai|vidau-geo') { return $true }
    }

    return $false
}

function Ensure-Node {
    if (Get-Command node -ErrorAction SilentlyContinue) { return }
    Write-Host 'Node.js is required. Install Node 18+ then re-run this script.' -ForegroundColor Red
    Write-Host 'Or run: node install-skills.mjs --from-cdn --force (after downloading the script)'
    exit 1
}

function Install-Skills {
    Ensure-Node

    $scriptPath = Join-Path $Tmp 'scripts\install-skills.mjs'

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host 'Git not found. Using CDN install (no clone)...'
        if (-not (Test-Path -LiteralPath $scriptPath)) {
            New-Item -ItemType Directory -Force -Path (Split-Path $scriptPath) | Out-Null
            Invoke-WebRequest -Uri 'https://geo.vidau.ai/skills/scripts/install-skills.mjs' -OutFile $scriptPath -UseBasicParsing
        }
        & node $scriptPath --from-cdn --force
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        return
    }

    if (-not (Test-Path -LiteralPath (Join-Path $Tmp '.git'))) {
        if (Test-Path -LiteralPath $Tmp) {
            Remove-Item -LiteralPath $Tmp -Recurse -Force
        }
        & git clone --depth 1 $Repo $Tmp
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }

    & node $scriptPath --force
    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host 'Installing VidAU GEO skills (clone + local copy)...'
Install-Skills

Write-Host ''
Write-Host 'Skills installed. Restart Hermes Desktop or run /reset to load them.'
Write-Host ''

if (Test-VidauMcpConfigured) {
    Write-Host 'MCP already connected (geo.vidau.ai). You are ready to use VidAU GEO.' -ForegroundColor Green
    exit 0
}

Write-Host '════════════════════════════════════════════════════════'
Write-Host '  MCP required — Skills are instructions only'
Write-Host '════════════════════════════════════════════════════════'
Write-Host ''
Write-Host 'Skills do not connect to VidAU. Without MCP you cannot'
Write-Host 'query data, write articles, or run audits.'
Write-Host ''
Write-Host 'Add to config.yaml:'
Write-Host ''
Write-Host 'mcp_servers:'
Write-Host '  vidau-geo:'
Write-Host '    url: https://geo.vidau.ai/mcp'
Write-Host '    enabled: true'
Write-Host '    connect_timeout: 60'
Write-Host '    timeout: 300'
Write-Host ''
Write-Host "Config file: $(Join-Path (Get-HermesHome) 'config.yaml')"
Write-Host 'Then: /reload-mcp or restart Hermes.'
Write-Host ''
exit 1
