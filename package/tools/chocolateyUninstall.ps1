$packageName = "SmartGit"
$installerType = "exe"

$folderName = "SmartGit"
$uninstallFile = "unins000.exe"

$key = "HKLM:\SOFTWARE\SmartGit"
$valueName = "ApplicationIcon"
$path = ""
$pathExists = $false

# Uninstall SmartGit if older version is installed
try {
    $path = (Get-ItemPropertyValue -Path $key -Name $valueName).replace("`"","")
    $path = (Get-Item $path).Directory.Parent.FullName
    $path = (Join-Path -Path $path -ChildPath $uninstallFile)
    $pathExists = Test-Path $path
}
catch [System.NullArgumentException]{
    $lastError = $Error[0]
    Write-Warning -Message "Failed to get uninstaller's path from Registry.`n$lastError`nTrying default paths..."
}
catch [System.Management.Automation.RuntimeException] {
    $lastError = $Error[0]
    Write-Warning -Message "Failed to get uninstaller's path from Registry.`n$lastError`nTrying default paths..."
}

if (Test-Path "$env:ProgramFiles\$folderName") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /NORESTART" "$env:ProgramFiles\$folderName\$uninstallFile"
}elseif (Test-Path "${env:ProgramFiles(x86)}\$folderName") {
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /NORESTART" "${env:ProgramFiles(x86)}\$folderName\$uninstallFile"
}elseif ($pathExists)
{
    Uninstall-ChocolateyPackage $packageName $installerType "/VERYSILENT /NORESTART" "$path"
}else {
    Write-Error -Message "No $packageName was found to uninstall."
}