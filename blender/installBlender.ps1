# Installs Blender and sets up work environment.

$verOld = "4.2"
$ver = "4.4"
$verSub = ".3"
$blenderPath = "$HOME/programs"
$extension = ".zip"
$package = "blender-$ver$verSub-windows-x64"
$webRequest = "https://ftp.blender.org/release/Blender$ver/$package$extension"
$configPath = "$env:APPDATA/Blender Foundation/Blender"
$dropboxConfigFiles = "https://www.dropbox.com/scl/fi/3mp73hnzl4eyuu5b4628g/configFiles.zip?rlkey=1snswsc65ouexugsmyj1gymum&st=slw6e39a&dl=1"


function InstallBlender {
  Write-Output "Downloading Blender..."
  Invoke-WebRequest -Uri "$webRequest" -OutFile "$blenderPath/"

  Write-Output "Extracting Blender..."
  Expand-Archive "$blenderPath/$package$extension" "$blenderPath/."

  Set-Location $blenderPath/
  Write-Output "Renaming Folder..."
  Move-Item -Path "$package" -Destination "Blender$ver" -Force 

  Write-Output "Copying config files to setup your envinronment..."
  Invoke-WebRequest -Uri "$dropboxConfigFiles" -OutFile "$blenderPath/configFiles.zip"
  Expand-Archive "$blenderPath/configFiles.zip" "$blenderPath/."
  Copy-Item -Path "$blenderPath/configFiles" -Destination "$configPath/$ver" -Force -Recurse

  Write-Output "Launching Blender..."
  Start-Process "$blenderPath/Blender$ver/blender.exe"

  Write-Output "Removing installation files..."
  Remove-Item -Path "$blenderPath/$package$extension" -Force
  Remove-Item -Path "$blenderPath/configFiles.zip" -Force
  Remove-Item -Path "$blenderPath/configFiles" -Force -Recurse

  Write-Output "Installation of Blender$ver$verSub complete..."
  }

function ConfigPaths {
  $blenderRoot = "$blenderPath/Blender$ver/$ver"

  $env:BLENDER_USER_CONFIG = "$blenderRoot/config"
  $env:BLENDER_USER_DATAFILES = "$blenderRoot/datafiles"
  $env:BLENDER_USER_SCRIPTS = "$blenderRoot/scripts"
  $env:BLENDER_USER_EXTENSIONS = "$blenderRoot/extensions"

  }

InstallBlender
# ConfigPaths

