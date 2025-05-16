param (
    [string]$Grep = "",
    [switch]$DryRun
)

# Global constants
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RunsDir = Join-Path $ScriptDir "runs"

function Main {
    Validate-Environment
    Log-RunInfo
    $scripts = Get-Scripts -Directory $RunsDir
    Run-Scripts -Scripts $scripts -Grep $Grep -DryRun:$DryRun
}

function Validate-Environment {
    if (-not $env:DEV_ENV) {
        Write-Host "ERROR: Environment variable DEV_ENV is required."
        exit 1
    }
}

function Log {
    param ($msg)
    if ($DryRun) {
        Write-Host "[DRY_RUN]: $msg"
    } else {
        Write-Host $msg
    }
}

function Log-RunInfo {
    Log "RUN: env: $($env:DEV_ENV) -- grep: '$Grep'"
    Log "Looking in: $RunsDir"
}

function Get-Scripts {
    param ([string]$Directory)
    return Get-ChildItem -Path $Directory -Filter "*.ps1" -File
}

function Run-Scripts {
    param (
        [array]$Scripts,
        [string]$Grep,
        [switch]$DryRun
    )

    foreach ($script in $Scripts) {
        if ($Grep -and ($script.Name -notmatch $Grep)) {
            Log "Grep filtered out: $($script.Name)"
            continue
        }

        Log "Running script: $($script.FullName)"
        if (-not $DryRun) {
            try {
                & $script.FullName
            } catch {
                Write-Host "❌ ERROR while running $($script.Name): $_"
            }
        }
    }
}

# Call main entry point
Main
