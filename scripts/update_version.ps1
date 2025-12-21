# PowerShell script to update version

# 读取版本号
$versionFile = "version.properties"
$version = (Get-Content $versionFile | Select-String '^version=').ToString().Split('=')[1]
$buildNumber = (Get-Content $versionFile | Select-String '^build_number=').ToString().Split('=')[1]

Write-Host "Updating version to $version+$buildNumber"

# 更新 pubspec.yaml
$pubspecPath = "pubspec.yaml"
$content = Get-Content $pubspecPath
$content = $content -replace '^version:.*', "version: $version+$buildNumber"
$content | Set-Content $pubspecPath

Write-Host "✅ Version updated successfully!"
Write-Host "pubspec.yaml: version: $version+$buildNumber"

