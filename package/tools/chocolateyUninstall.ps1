$packageName = "SmartGit"
$installerType = "exe"

$folderName = "SmartGit"
$uninstallFile = "unins000.exe"

# Uninstall SmartGit if older version is installed
if (Test-Path "$env:ProgramFiles\$folderName") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /NORESTART" "$env:ProgramFiles\$folderName\$uninstallFile"
}

if (Test-Path "${env:ProgramFiles(x86)}\$folderName") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /NORESTART" "${env:ProgramFiles(x86)}\$folderName\$uninstallFile"
}