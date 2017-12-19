$ErrorActionPreference = 'Stop'

$version = '17_1_3'
$fileName = "smartgit-win32-setup-jre-$version.zip"
$packageArgs = @{
    packageName    = 'SmartGit'
    fileType       = 'exe'
    softwareName   = 'SmartGit'
    unzipLocation  = Get-PackageCacheLocation

    checksum       = 'A3DA0E8B86195F749BBD895405FE35C03EA9E658'
    checksumType   = 'sha1'
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
