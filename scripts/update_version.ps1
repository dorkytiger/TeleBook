# PowerShell script to update version

# 读取版本号
$versionFile = "version.properties"
$versionName = (Get-Content $versionFile | Select-String '^VERSION_NAME=').ToString().Split('=')[1]
$versionCode = (Get-Content $versionFile | Select-String '^VERSION_CODE=').ToString().Split('=')[1]

Write-Host "🔄 Updating version to $versionName+$versionCode"

# 更新 pubspec.yaml
$pubspecPath = "pubspec.yaml"
$content = Get-Content $pubspecPath
$content = $content -replace '^version:.*', "version: $versionName+$versionCode"
$content | Set-Content $pubspecPath

Write-Host "✅ Version updated successfully!"
Write-Host "   pubspec.yaml: version: $versionName+$versionCode"


