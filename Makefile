.PHONY: version build-android build-windows help

help:
	@echo "可用命令:"
	@echo "  make version         - 从 version.properties 更新版本号到 pubspec.yaml"
	@echo "  make build-android   - 构建 Android APK"
	@echo "  make build-windows   - 构建 Windows 应用"
	@echo "  make release         - 创建新版本发布（提交+打标签+推送）"

version:
	@echo "正在从 version.properties 读取版本号..."
	@dart run scripts/update_version.dart

build-android: version
	@echo "正在构建 Android APK..."
	@flutter build apk --release

build-windows: version
	@echo "正在构建 Windows 应用..."
	@flutter build windows --release

release: version
	@echo "准备发布新版本..."
	@powershell -Command "\
		$$versionName = (Get-Content version.properties | Select-String '^VERSION_NAME=').ToString().Split('=')[1]; \
		$$versionCode = (Get-Content version.properties | Select-String '^VERSION_CODE=').ToString().Split('=')[1]; \
		git add version.properties pubspec.yaml; \
		git commit -m \"chore: bump version to v$$versionName (build $$versionCode)\"; \
		git tag v$$versionName; \
		git push origin main --tags; \
		Write-Host '✅ 版本 v'$$versionName' (build '$$versionCode') 已发布！'"


