$ErrorActionPreference = 'Stop'

$version = '18_2_8'
$fileName = "smartgit-win-$version.zip"
$packageArgs = @{
    packageName    = 'SmartGit'
    fileType       = 'exe'
    softwareName   = 'SmartGit'
    unzipLocation  = Get-PackageCacheLocation

    checksum       = '5902C2E1E36D6AAEDC7F2047D31B4BEA0DE1D398AA62F46E09368F6A36955414'
    checksumType   = 'sha256'
    url            = "https://www.syntevo.com/downloads/smartgit/$fileName"

    silentArgs     = '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Write-Verbose "Testing the default url location."
if ((Get-WebHeaders $packageArgs.url).'Content-Type' -match "^text/html" ) {
  Write-Warning "File not found, trying to find it in the archive."
  $packageArgs.url = "https://www.syntevo.com/downloads/smartgit/archive/$fileName"
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = (Join-Path $packageArgs.unzipLocation (Get-ChildItem $packageArgs.unzipLocation -Filter '*.exe' | select -first 1))

Install-ChocolateyInstallPackage @packageArgs
