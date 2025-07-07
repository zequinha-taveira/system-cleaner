<#
.SYNOPSIS
    A robust and safe script to clean and optimize Windows systems.
.DESCRIPTION
    Performs a deep clean of temporary files, logs, and caches.
    Offers optimization features and multiple operational modes for safety and automation.
.PARAMETER DryRun
    Simulates the cleaning process, showing what would be done without making changes.
.PARAMETER Silent
    Executes the script without any interactive prompts, useful for scheduled tasks.
.PARAMETER SafeOnly
    Performs only 100% non-destructive cleaning actions.
.PARAMETER LogPath
    Specifies a custom path for the log file.
.EXAMPLE
    .PowerShell.exe -ExecutionPolicy Bypass -File .\limpeza-avancada-windows.ps1 -SafeOnly
.EXAMPLE
    .PowerShell.exe -ExecutionPolicy Bypass -File .\limpeza-avancada-windows.ps1 -DryRun
.NOTES
    Author: Gemini AI
    Version: 1.0
#>
[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param(
    [switch]$DryRun,
    [switch]$Silent,
    [switch]$SafeOnly,
    [string]$LogPath = "C:\Logs\limpeza-$(Get-Date -Format 'yyyy-MM-dd').log"
)

# --- Initial Setup ---
$startTime = Get-Date
$totalFreedSpace = 0

# --- Helper Functions ---

# Function to write to log and console
function Write-Log {
    param ([string]$Message, [string]$Color = 'White')
    $timestampedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $Message"
    Write-Host $timestampedMessage -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $timestampedMessage
}

# Function to safely execute cleaning actions
function Invoke-CleaningAction {
    param (
        [string]$Description,
        [scriptblock]$Action,
        [switch]$IsDestructive
    )

    Write-Log -Message "--> Executing: $Description" -Color 'Yellow'

    if ($SafeOnly -and $IsDestructive) {
        Write-Log "    -> SKIPPED (SafeOnly mode is active)." -Color 'Cyan'
        return
    }

    if (-not $Silent) {
        $confirm = Read-Host "    Do you want to proceed with this step? (Y/N)" 
        if ($confirm -ne 'y') {
            Write-Log "    -> SKIPPED by user confirmation." -Color 'Cyan'
            return
        }
    }

    if ($DryRun) {
        Write-Log "    [DRY-RUN] Action for '$Description' would be executed." -Color 'Magenta'
        return
    }

    try {
        $spaceBefore = (Get-ChildItem -Path $env:SystemDrive -Force | Measure-Object -Property Length -Sum).Sum
        
        # Execute the provided script block
        Invoke-Command -ScriptBlock $Action

        $spaceAfter = (Get-ChildItem -Path $env:SystemDrive -Force | Measure-Object -Property Length -Sum).Sum
        $freed = $spaceBefore - $spaceAfter
        $totalFreedSpace += $freed

        Write-Log "    -> SUCCESS. Space freed: $([math]::Round($freed / 1MB, 2)) MB" -Color 'Green'
    } catch {
        Write-Log "    -> ERROR: $($_.Exception.Message)" -Color 'Red'
    }
}

# --- Pre-flight Checks ---

# 1. Administrator Check
Write-Log "Checking for Administrator privileges..."
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Log "ERROR: This script must be run with Administrator privileges." -Color Red
    exit 1
}
Write-Log "Administrator privileges confirmed." -Color Green

# 2. Log File Setup
$logDir = Split-Path -Path $LogPath -Parent
if (-not (Test-Path -Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}
$LogFile = $LogPath
Write-Log "Logging to: $LogFile"

# --- Main Script Body ---

if ($DryRun) {
    Write-Log "*** DRY-RUN MODE ENABLED. NO CHANGES WILL BE MADE. ***" -Color 'Magenta'
}

# --- Cleaning Actions ---

# 1. Temporary Files
Invoke-CleaningAction -Description "Clean standard temporary folders (%TEMP%, C:\Windows\Temp)" -Action {
    Get-ChildItem -Path @("$env:TEMP", "$env:windir\Temp") -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
} -IsDestructive

# 2. Windows Update Cache
Invoke-CleaningAction -Description "Clean Windows Update cache (SoftwareDistribution)" -Action {
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path "$env:windir\SoftwareDistribution\Download" -Recurse -Force | Remove-Item -Recurse -Force
    Start-Service -Name wuauserv
} -IsDestructive

# 3. Clear Recycle Bin
Invoke-CleaningAction -Description "Empty the Recycle Bin" -Action {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
} -IsDestructive

# 4. Other System Caches
Invoke-CleaningAction -Description "Clean various system caches (Store, Thumbs.db, etc.)" -Action {
    # Windows Store Cache
    Get-ChildItem -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore*\LocalCache" -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    # Thumbnail Cache
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force | Remove-Item -Force
    Start-Process explorer
} -IsDestructive

# --- System Optimization Actions ---

if (-not $SafeOnly) {
    # 5. System File Checker (SFC)
    Invoke-CleaningAction -Description "Run System File Checker (sfc /scannow)" -Action {
        sfc.exe /scannow
    }

    # 6. DISM Component Cleanup
    Invoke-CleaningAction -Description "Run DISM Component Cleanup" -Action {
        Dism.exe /Online /Cleanup-Image /StartComponentCleanup
    }
}

# --- Final Summary ---
$endTime = Get-Date
$duration = $endTime - $startTime

Write-Log "==================== CLEANING SUMMARY ====================" -Color 'Green'
Write-Log "Total space freed: $([math]::Round($totalFreedSpace / 1GB, 3)) GB ($([math]::Round($totalFreedSpace / 1MB, 2)) MB)" -Color 'Green'
Write-Log "Total execution time: $($duration.Hours)h $($duration.Minutes)m $($duration.Seconds)s" -Color 'Green'
Write-Log "Log file available at: $LogFile" -Color 'Green'
Write-Log "=========================================================" -Color 'Green'
