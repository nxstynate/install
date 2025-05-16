$source = "$PSScriptRoot\..\files\powershell\Microsoft.PowerShell_profile.ps1"
$target = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path (Split-Path $target) -Force
    Copy-Item $source $target
    Write-Host "Linked PowerShell profile"
} else {
    Write-Host "PowerShell profile already exists"
}

New-Item -ItemType SymbolicLink -Path $target -Target $source
