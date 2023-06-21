$ErrorActionPreference = 'Stop'

# Todo: Use javascript in a GitHub workflow to get the URL and hash of latest download
# Check https://www.syntevo.com/smartgit/autoupdate for latest version
$version = '22_1_5'

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

    checksum64       = '748E293D243566A02FC43F75DCEA88739709CD67FCC3B7ADCD97B18E2A7D1455'
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