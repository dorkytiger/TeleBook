.PHONY: version help

help:
	@echo "可用命令:"
	@echo "  make version    - 从 version.properties 更新版本号到 pubspec.yaml"
	@echo "  make release    - 创建新版本发布（提交+打标签+推送）"

version:
	@echo "正在从 version.properties 读取版本号..."
	@powershell -ExecutionPolicy Bypass -File scripts/update_version.ps1

release: version
	@echo "准备发布新版本..."
	@powershell -Command "\
		$$version = (Get-Content version.properties | Select-String '^version=').ToString().Split('=')[1]; \
		git add version.properties pubspec.yaml; \
		git commit -m \"chore: bump version to v$$version\"; \
		git tag v$$version; \
		git push origin main --tags; \
		Write-Host '✅ 版本 v'$$version' 已发布！'"

