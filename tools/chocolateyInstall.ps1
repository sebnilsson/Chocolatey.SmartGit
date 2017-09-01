$ErrorActionPreference = 'Stop'

$version = '17_0_5'
$fileName = "smartgit-win32-setup-jre-$version.zip"
$packageArgs = @{
    packageName    = 'SmartGit'
    fileType       = 'exe'
    softwareName   = 'SmartGit'
    unzipLocation  = Get-PackageCacheLocation

    checksum       = '0809cd9007ab2f6f67cd12bebdf657669764bfb5'
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
