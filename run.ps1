param (
    [string]$Grep = "",
    [switch]$DryRun
)

# Global constants
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RunsDir = Join-Path $ScriptDir "runs"

# Entry point
function Main {
    Validate-Environment
    Log-RunInfo
    $scripts = Get-Scripts -Directory $RunsDir
    Run-Scripts -Scripts $scripts -Grep $Grep -DryRun:$DryRun
}

# Ensure DEV_ENV is defined
function Validate-Environment {
    if (-not $env:DEV_ENV) {
        Write-Host "ERROR: Environment variable DEV_ENV is required."
        exit 1
    }
}

# Output environment and grep info
function Log-RunInfo {
    Log "RUN: env: $($env:DEV_ENV) -- grep: '$Grep'"
}

# Find all .ps1 scripts in the runs folder
function Get-Scripts {
    param ([string]$Directory)

    if (-not (Test-Path $Directory)) {
        Write-Host "ERROR: '$Directory' does not exist."
        exit 1
    }

    return Get-ChildItem -Path $Directory -Filter "*.ps1" -File
}

# Filter and run scripts
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
                Write-Host "ERROR while running $($script.Name): $_"
            }
        }
    }
}

# Logging helper
function Log {
    param ([string]$Message)

    if ($DryRun) {
        Write-Host "[DRY_RUN]: $Message"
    } else {
        Write-Host $Message
    }
}

# Run it
Main
