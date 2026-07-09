#Requires -Version 5.1
# Install all VidAU GEO Agent skills into Hermes (Windows native).
# Usage:
#   irm https://geo.vidau.ai/skills/install.ps1 | iex
#   irm https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main/install.ps1 | iex

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoBase = if ($env:VIDAU_GEO_SKILLS_BASE) {
    $env:VIDAU_GEO_SKILLS_BASE.TrimEnd('/')
} else {
    'https://raw.githubusercontent.com/vidaudeveloper/Vidau-Geo-Agent/main'
}

$SkillIds = @(
    'vidau-geo-mcp-setup',
    'vidau-geo-quick-audit',
    'vidau-geo-full-audit',
    'vidau-geo-brand-insights',
    'vidau-geo-compose',
    'vidau-geo-publish',
    'vidau-geo-write-draft',
    'vidau-geo-automation'
)

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

function Invoke-Hermes {
    param(
        [Parameter(Mandatory)]
        [string[]]$Args
    )

    $cli = Resolve-HermesCli
    if (-not $cli) {
        Write-Host 'Hermes CLI not found.' -ForegroundColor Red
        Write-Host ''
        Write-Host 'Install Hermes Desktop, or run the Hermes Windows installer:'
        Write-Host '  irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex'
        Write-Host ''
        Write-Host 'After install, open a new PowerShell window and run this script again.'
        Write-Host 'Docs: https://hermes-agent.nousresearch.com/docs/user-guide/windows-native'
        exit 1
    }

    & $cli @Args
    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
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
        if ($content -match 'geo\.vidau\.ai') { return $true }
    }

    return $false
}

Write-Host "Installing $($SkillIds.Count) VidAU GEO skills from $RepoBase..."

foreach ($skill in $SkillIds) {
    Write-Host "→ $skill"
    Invoke-Hermes -Args @('skills', 'install', "$RepoBase/$skill/SKILL.md")
}

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
Write-Host '1. Open https://geo.vidau.ai/developer and create an API Key'
Write-Host '2. Connect MCP (pick one):'
Write-Host ''
Write-Host '   hermes mcp add vidau-geo --url https://geo.vidau.ai/mcp --header "x-api-key=YOUR_KEY"'
Write-Host ''
Write-Host '   Or edit config.yaml in Hermes Desktop → Settings:'
Write-Host "     $(Join-Path (Get-HermesHome) 'config.yaml')"
Write-Host ''

$apiKey = Read-Host 'Paste API Key to configure now (Enter to skip)'
if ($apiKey) {
    Invoke-Hermes -Args @(
        'mcp', 'add', 'vidau-geo',
        '--url', 'https://geo.vidau.ai/mcp',
        '--header', "x-api-key=$apiKey"
    )
    Write-Host ''
    Write-Host 'MCP configured. Restart Hermes or /reload-mcp, then /reset.' -ForegroundColor Green
    exit 0
}

Write-Host 'Skipped MCP setup. Configure later at https://geo.vidau.ai/developer'
Write-Host 'Then: restart Hermes or /reload-mcp'
exit 1
