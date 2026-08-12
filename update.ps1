#Requires -Version 5.1

param(
    [string]$LogFile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$env:GIT_TERMINAL_PROMPT = '0'
$env:GCM_INTERACTIVE = 'never'

if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    throw 'Dieses Skript ist für natives Windows gedacht. Unter macOS, Linux oder WSL bitte update.sh verwenden.'
}

$RepoDir = [System.IO.Path]::GetFullPath($PSScriptRoot)

if ($null -eq (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git ist nicht verfügbar.'
}

$IsRepositoryOutput = (& git -C $RepoDir rev-parse --is-inside-work-tree 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($IsRepositoryOutput)) {
    throw "Kein Git-Repository: $RepoDir"
}
if ($IsRepositoryOutput.Trim() -ne 'true') {
    throw "Kein Git-Repository: $RepoDir"
}

if ([string]::IsNullOrWhiteSpace($LogFile)) {
    $CodexDir = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        Join-Path ([System.Environment]::GetFolderPath('UserProfile')) '.codex'
    }
    else {
        [System.IO.Path]::GetFullPath($env:CODEX_HOME)
    }

    $LogFile = Join-Path $CodexDir 'codex-config-update.log'
}

$LogFile = [System.IO.Path]::GetFullPath($LogFile)
$LogDirectory = Split-Path -Parent $LogFile
New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null

function Write-UpdateLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $Timestamp = Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'
    $Line = "$Timestamp $Message"
    Write-Host $Line
    Add-Content -LiteralPath $LogFile -Value $Line
}

function Stop-Update {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-UpdateLog "FEHLER: $Message"
    throw $Message
}

$Status = @(& git -C $RepoDir status --porcelain)
if ($LASTEXITCODE -ne 0) {
    Stop-Update 'Git-Status konnte nicht gelesen werden.'
}
if ($Status.Count -gt 0) {
    Stop-Update 'Der Worktree enthält lokale Änderungen; Auto-Update übersprungen.'
}

$BranchOutput = (& git -C $RepoDir branch --show-current)
if ($LASTEXITCODE -ne 0) {
    Stop-Update 'Aktueller Branch konnte nicht ermittelt werden.'
}
$Branch = ([string]$BranchOutput).Trim()
if ([string]::IsNullOrWhiteSpace($Branch)) {
    Stop-Update 'Detached HEAD; Auto-Update übersprungen.'
}

& git -C $RepoDir rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' *> $null
if ($LASTEXITCODE -ne 0) {
    Stop-Update "Für $Branch ist kein Upstream konfiguriert."
}

$BeforeOutput = (& git -C $RepoDir rev-parse --short HEAD)
if ($LASTEXITCODE -ne 0) {
    Stop-Update 'Aktueller Commit konnte nicht gelesen werden.'
}
$Before = ([string]$BeforeOutput).Trim()

$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    & git -C $RepoDir pull --ff-only *> $null
    $PullExitCode = $LASTEXITCODE
}
finally {
    $ErrorActionPreference = $PreviousErrorActionPreference
}
if ($PullExitCode -ne 0) {
    Stop-Update 'git pull --ff-only ist fehlgeschlagen; bitte einmal manuell prüfen.'
}

$AfterOutput = (& git -C $RepoDir rev-parse --short HEAD)
if ($LASTEXITCODE -ne 0) {
    Stop-Update 'Neuer Commit konnte nicht gelesen werden.'
}
$After = ([string]$AfterOutput).Trim()

if ($Before -eq $After) {
    Write-UpdateLog "Bereits aktuell auf $Branch ($After)."
}
else {
    Write-UpdateLog "Aktualisiert: $Branch $Before -> $After."
}
