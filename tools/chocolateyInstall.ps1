$ErrorActionPreference = 'Stop'

$version = '8_0_0'
$fileName = "smartgit-win32-setup-nojre-$version.zip"
$packageArgs = @{
    packageName    = 'SmartGit'
    fileType       = 'exe'
    softwareName   = 'SmartGit'
    unzipLocation  = Get-PackageCacheLocation

    checksum       = ''
    checksumType   = ''
    url            = "https://www.syntevo.com/static/smart/download/smartgit/$fileName"

    silentArgs     = '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes = @(0)
}

Write-Verbose "Testing the default url location."
if ((Get-WebHeaders $packageArgs.url).'Content-Type' -match "^text/html" ) {
  Write-Warning "File not found, trying to find it in the archive."
  $packageArgs.url = "https://www.syntevo.com/static/smart/download/smartgithg/archive/$fileName"
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs.file = (Join-Path $packageArgs.unzipLocation (Get-ChildItem $packageArgs.unzipLocation -Filter '*.exe' | select -first 1))

Install-ChocolateyInstallPackage @packageArgs

Uninstall-ChocolateyZipPackage -PackageName $packageArgs.packageName -ZipFileName $fileName
