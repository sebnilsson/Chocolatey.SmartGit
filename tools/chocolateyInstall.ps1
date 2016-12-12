$packageName = 'SmartGit'
$version = '8_0_0'
$fileType = '.zip'
$silentArgs = '/sp- /silent /norestart'

$url = 'http://www.syntevo.com/static/smart/download/smartgit/smartgit-win32-setup-nojre-' + $version + $fileType

$httpRequest = [System.Net.WebRequest]::Create($url)
$httpResponse = $httpRequest.GetResponse()
$httpStatus = [int]$httpResponse.StatusCode

if (!($httpStatus = 200)) {
    Write-Error "File not found, trying to find it in the archive"
    $url = 'http://www.syntevo.com/smartgit/download-archive?file=smartgithg/archive/smartgit-win32-setup-nojre-' + $version + $fileType
}

$unzipLocation = $(Split-Path -Parent $MyInvocation.MyCommand.Definition)

$installFileLocation = [io.path]::combine($unzipLocation, "setup-" + $version + ".exe")
$changeLogFileLocation = [io.path]::combine($unzipLocation, "changelog.txt")

Install-ChocolateyZipPackage -PackageName $packageName -Url $url -UnzipLocation $unzipLocation

Install-ChocolateyInstallPackage -PackageName $packageName -FileType "exe" -SilentArgs $silentArgs -File $installFileLocation

Remove-Item $installFileLocation
Remove-Item $changeLogFileLocation