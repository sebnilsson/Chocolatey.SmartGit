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

    checksum64       = '30AB1489BCDE76B966615F16DBB0564A45935266FDB93B84DCAB6B5EDDF99EFB'
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