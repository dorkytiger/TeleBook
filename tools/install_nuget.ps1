# PowerShell 脚本：下载 nuget.exe 到 tools\nuget 并给出后续提示

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$targetDir = Join-Path $repoRoot "nuget"
$targetPath = Join-Path $targetDir "nuget.exe"
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

Write-Host "Downloading nuget.exe -> $targetPath ..."
Invoke-WebRequest -Uri $nugetUrl -OutFile $targetPath -UseBasicParsing

if (Test-Path $targetPath) {
    Write-Host "下载完成： $targetPath"
    Write-Host ""
    Write-Host "请将该目录加入系统 PATH，或在系统环境变量中设置 NUGET_EXECUTABLE 指向完整路径："
    Write-Host "  例如（PowerShell 临时）：$env:NUGET_EXECUTABLE = '$targetPath'"
    Write-Host "  或永久在 系统 属性 -> 环境变量 中添加：D:\\StudioProjects\\TeleBook\\tools\\nuget"
    Write-Host ""
    Write-Host "然后重新运行 Flutter 构建（例如：flutter build windows 或 flutter run -d windows）。"
} else {
    Write-Error "下载失败，请手动访问 https://dist.nuget.org/win-x86-commandline/latest/nuget.exe 下载并放到 tools\\nuget\\nuget.exe"
}

