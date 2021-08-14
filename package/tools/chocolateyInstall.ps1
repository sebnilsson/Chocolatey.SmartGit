$ErrorActionPreference = 'Stop'

# Todo: Use javascript in a GitHub workflow to get the URL and hash of latest download
$version = '21_1_1'

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

    checksum64       = '3CFF55681DF7E5AA23ED52464234FB69349CDFA710A8235CDF87620F671519E3'
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