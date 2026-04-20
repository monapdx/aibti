# AIBTI · Updater (Windows PowerShell)
# Usage: irm https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/update.ps1 | iex
#
# Pulls latest SKILL.md + report template + portraits.
# Keeps your data intact: ~/.aibti/prompts.jsonl and report.html are never touched.

$ErrorActionPreference = "Stop"
$Raw = "https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
$Api = "https://api.github.com/repos/leefufufufufu-rgb/aibti"
$SkillDir = Join-Path $env:USERPROFILE ".claude\skills\aibti"
$DataDir  = Join-Path $env:USERPROFILE ".aibti"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  AIBTI Updater · Pulling latest" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

if (-not (Test-Path $SkillDir)) {
    Write-Host "⚠  AIBTI not installed yet. Run the installer first:" -ForegroundColor Yellow
    Write-Host "   irm $Raw/install.ps1 | iex"
    exit 1
}

# Recent commits
Write-Host "Recent updates:" -ForegroundColor DarkGray
try {
    $commits = Invoke-RestMethod "$Api/commits?per_page=3" -UseBasicParsing
    foreach ($c in $commits) {
        $msg = ($c.commit.message -split "`n")[0]
        if ($msg.Length -gt 80) { $msg = $msg.Substring(0, 80) }
        Write-Host "  · $msg" -ForegroundColor DarkGray
    }
} catch { Write-Host "  (changelog unavailable)" -ForegroundColor DarkGray }
Write-Host ""

# Skill
Write-Host -NoNewline "[1/2] Updating Skill ... " -ForegroundColor Yellow
Invoke-WebRequest -UseBasicParsing "$Raw/skills/aibti/SKILL.md" -OutFile (Join-Path $SkillDir "SKILL.md")
Write-Host "✓" -ForegroundColor Green

# Template + SVGs
Write-Host "[2/2] Updating report assets ..." -ForegroundColor Yellow
$PortraitDir = Join-Path $DataDir "portraits"
New-Item -ItemType Directory -Force -Path $PortraitDir | Out-Null
Invoke-WebRequest -UseBasicParsing "$Raw/report-template.html" -OutFile (Join-Path $DataDir "report-template.html")

$Portraits = @("amde","amdx","amle","amlx","avde","avdx","avle","avlx","cmde","cmdx","cmle","cmlx","cvde","cvdx","cvle","cvlx")
$Total = $Portraits.Count
for ($i = 0; $i -lt $Total; $i++) {
    $code = $Portraits[$i]
    $n = $i + 1
    Write-Host -NoNewline ("`r  [{0,2}/{1}] {2}.svg ... " -f $n, $Total, $code)
    try { Invoke-WebRequest -UseBasicParsing "$Raw/portraits/$code.svg" -OutFile (Join-Path $PortraitDir "$code.svg") } catch {}
}
Write-Host ("`r  ✓ {0} portrait SVGs refreshed                                       " -f $Total) -ForegroundColor Green

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  ✓ Updated. Your data (~/.aibti/prompts.jsonl, report.html) untouched." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "Run 'Analyze my AIBTI' in Claude Code to see the new version in action." -ForegroundColor Cyan
