$ErrorActionPreference = 'Stop'

$version = '20_1_5'

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

    checksum64       = 'B35F60AE660805E2091B821645D3C215EE66B9D1294D42E28ED416AAA517A6A8'
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