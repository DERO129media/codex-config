#Requires -Version 5.1

param(
    [switch]$EnableAutoUpdate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    throw 'Dieses Skript ist für natives Windows gedacht. Unter macOS, Linux oder WSL bitte install.sh verwenden.'
}

function Enable-CodexConfigAutoUpdate {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UpdateScript,

        [Parameter(Mandatory = $true)]
        [string]$LogFile
    )

    if (-not (Test-Path -LiteralPath $UpdateScript -PathType Leaf)) {
        throw "Updater fehlt: $UpdateScript"
    }

    Import-Module ScheduledTasks -ErrorAction Stop

    $TaskName = 'DERO Codex Config Auto Update'
    $PowerShellExecutable = (Get-Process -Id $PID).Path
    $Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$UpdateScript`" -LogFile `"$LogFile`""
    $FirstRun = (Get-Date).AddMinutes(1)

    $Action = New-ScheduledTaskAction -Execute $PowerShellExecutable -Argument $Arguments
    $Trigger = New-ScheduledTaskTrigger `
        -Once `
        -At $FirstRun `
        -RepetitionInterval (New-TimeSpan -Minutes 15) `
        -RepetitionDuration (New-TimeSpan -Days 3650)
    $Settings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -MultipleInstances IgnoreNew `
        -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
    $Principal = New-ScheduledTaskPrincipal `
        -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
        -LogonType Interactive `
        -RunLevel Limited

    Register-ScheduledTask `
        -TaskName $TaskName `
        -Description 'Aktualisiert die globale Dennis-Codex-Konfiguration alle 15 Minuten.' `
        -Action $Action `
        -Trigger $Trigger `
        -Settings $Settings `
        -Principal $Principal `
        -Force | Out-Null

    Start-ScheduledTask -TaskName $TaskName
    Write-Host 'Auto-Update aktiviert: Die Windows-Aufgabenplanung prüft das Repository alle 15 Minuten.'
}

$RepoDir = [System.IO.Path]::GetFullPath($PSScriptRoot)
$Source = Join-Path $RepoDir 'AGENTS.md'

if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    $UserProfile = [System.Environment]::GetFolderPath('UserProfile')
    if ([string]::IsNullOrWhiteSpace($UserProfile)) {
        throw 'Weder CODEX_HOME noch ein Benutzerprofil ist verfügbar.'
    }

    $CodexDir = Join-Path $UserProfile '.codex'
}
else {
    $CodexDir = [System.IO.Path]::GetFullPath($env:CODEX_HOME)
}

if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
    throw "Quelldatei fehlt: $Source"
}

New-Item -ItemType Directory -Path $CodexDir -Force | Out-Null
$CodexDir = [System.IO.Path]::GetFullPath($CodexDir)
$Target = Join-Path $CodexDir 'AGENTS.md'
$Existing = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue

$IsCorrectLink = $false
if ($null -ne $Existing -and $Existing.LinkType -eq 'SymbolicLink') {
    $LinkTarget = [string]@($Existing.Target)[0]
    if (-not [System.IO.Path]::IsPathRooted($LinkTarget)) {
        $LinkTarget = Join-Path $Existing.DirectoryName $LinkTarget
    }

    $IsCorrectLink = [System.StringComparer]::OrdinalIgnoreCase.Equals(
        [System.IO.Path]::GetFullPath($LinkTarget),
        $Source
    )
}

$Backup = $null

if ($IsCorrectLink) {
    Write-Host "Symlink ist bereits korrekt:`n$Target -> $Source"
}
else {
    if ($null -ne $Existing -and $Existing.PSIsContainer -and $Existing.LinkType -ne 'SymbolicLink') {
        throw "Ziel ist ein Verzeichnis und wird nicht automatisch ersetzt: $Target"
    }

    if ($null -ne $Existing) {
        $Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $Backup = "$Target.backup.$Timestamp"

        if ($null -ne (Get-Item -LiteralPath $Backup -Force -ErrorAction SilentlyContinue)) {
            throw "Backup-Ziel existiert bereits: $Backup"
        }

        Move-Item -LiteralPath $Target -Destination $Backup
        Write-Host "Bestehendes Ziel gesichert:`n$Backup"
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    }
    catch {
        $BackupHint = if ($null -ne $Backup) { " Das vorherige Ziel liegt unter: $Backup" } else { '' }
        throw "Symlink konnte nicht erstellt werden. Prüfe Windows-Entwicklermodus oder Administratorrechte.$BackupHint $($_.Exception.Message)"
    }

    $Created = Get-Item -LiteralPath $Target -Force
    $CreatedTarget = [System.IO.Path]::GetFullPath([string]@($Created.Target)[0])

    if ($Created.LinkType -ne 'SymbolicLink' -or
        -not [System.StringComparer]::OrdinalIgnoreCase.Equals($CreatedTarget, $Source)) {
        throw "Symlink konnte nicht verifiziert werden: $Target"
    }

    Write-Host "Symlink erstellt:`n$Target -> $Source"
}

if ($EnableAutoUpdate) {
    Enable-CodexConfigAutoUpdate `
        -UpdateScript (Join-Path $RepoDir 'update.ps1') `
        -LogFile (Join-Path $CodexDir 'codex-config-update.log')
}
