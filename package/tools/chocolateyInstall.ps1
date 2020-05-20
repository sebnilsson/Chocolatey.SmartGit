$ErrorActionPreference = 'Stop'

$version = '20_1_2'

$packageName = 'SmartGit'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileName = "smartgit-win-$version.zip"
$url = "https://www.syntevo.com/downloads/smartgit/$fileName"
$archiveUrl = "https://www.syntevo.com/downloads/smartgit/archive/$fileName"
$file = Join-Path $toolsDir "smartgit-$version-setup.exe"

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $toolsDir
    url64            = $url

    checksum64       = 'DB1472C5982C5659E43A93269EE9A6641E545C333767D2B432AD4839FB4F1CCC'
    checksumType64   = 'sha256'
}

$installArgs = @{
  packageName    = $packageName
  file = $file

  silentArgs     = '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Write-Verbose "Testing the default url location."

if ((Get-WebHeaders $packageArgs.url).'Content-Type' -match "^text/html" ) {
  Write-Warning "File not found, trying to find it in the archive."
  $packageArgs.url = $archiveUrl
}

Install-ChocolateyZipPackage @packageArgs

Install-ChocolateyInstallPackage @installArgs