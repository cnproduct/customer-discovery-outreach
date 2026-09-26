param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path -LiteralPath $RepoPath).Path
$logDir = Join-Path $env:LOCALAPPDATA 'Codex\skill-publisher'
$logFile = Join-Path $logDir 'customer-discovery-outreach.log'
$null = New-Item -ItemType Directory -Path $logDir -Force

function Write-Log([string]$Message) {
    Add-Content -LiteralPath $logFile -Value "$(Get-Date -Format o) $Message" -Encoding UTF8
}

$mutex = [System.Threading.Mutex]::new($false, 'Local\CodexSkillPublishCustomerDiscoveryOutreach')
if (-not $mutex.WaitOne(0)) { exit 0 }

try {
    $scope = @('SKILL.md', 'README.md', '.gitignore', 'references', 'scripts')
    & git -C $repo add -- $scope
    if ($LASTEXITCODE -ne 0) { throw 'git add failed' }

    & git -C $repo diff --cached --quiet
    if ($LASTEXITCODE -eq 0) { exit 0 }
    if ($LASTEXITCODE -ne 1) { throw 'git diff failed' }

    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    & git -C $repo commit -m "chore(skill): auto-publish $stamp" --quiet
    if ($LASTEXITCODE -ne 0) { throw 'git commit failed' }

    & git -C $repo push --quiet
    if ($LASTEXITCODE -ne 0) { throw 'git push failed; local commit retained for retry' }
    Write-Log 'Published skill changes.'
}
catch {
    Write-Log "Publish failed: $($_.Exception.Message)"
    exit 1
}
finally {
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
