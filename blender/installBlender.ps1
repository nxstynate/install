# Installs Blender and sets up work environment.

$verOld = "4.2"
$ver = "4.4"
$verSub = ".3"
$blenderPath = "$HOME/programs"
$extension = ".zip"
$package = "blender-$ver$verSub-windows-x64"
$webRequest = "https://ftp.blender.org/release/Blender$ver/$package$extension"
$configPath = "$env:APPDATA/Blender Foundation/Blender"

function InstallBlender {
  Write-Output "Downloading Blender..."
  Invoke-WebRequest -Uri "$webRequest" -OutFile "$blenderPath/"

  Write-Output "Extracting Blender..."
  Expand-Archive "$blenderPath/$package$extension" "$blenderPath/."

  Set-Location $blenderPath/
  Write-Output "Renaming Folder..."

  Move-Item -Path "$package" -Destination "Blender$ver" -Force 
  Write-Output "Copying config files to setup your envinronment..."
  Copy-Item -Path "$configPath/$verOld" -Destination "$configPath/$ver" -Force -Recurse

  Write-Output "Launching Blender..."
  Start-Process "$blenderPath/Blender$ver/blender.exe"

  Write-Output "Removing zip file..."
  Remove-Item -Path "$blenderPath/$package$extension"

  Write-Output "Installation of Blender$ver$verSub complete..."
  }
C:\Users\Paul\programs\Blender4.4\4.4

function ConfigPaths {
  $blenderRoot = "$blenderPath/Blender$ver/$ver"

  $env:BLENDER_USER_CONFIG = "$blenderRoot/config"
  $env:BLENDER_USER_DATAFILES = "$blenderRoot/datafiles"
  $env:BLENDER_USER_SCRIPTS = "$blenderRoot/scripts"

  }

InstallBlender
# ConfigPaths

