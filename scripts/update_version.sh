#!/bin/bash

# 切换到脚本所在目录的上级（项目根目录），保证从任意位置运行都能找到文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1

# 检查必需文件
if [ ! -f version.properties ]; then
  echo "❌ version.properties 文件不存在（应在项目根目录）"
  exit 1
fi
if [ ! -f pubspec.yaml ]; then
  echo "❌ pubspec.yaml 文件不存在（应在项目根目录）"
  exit 1
fi

# 读取版本号（与 CI / update_version.dart 一致的字段名）
VERSION_NAME=$(grep '^VERSION_NAME=' version.properties | cut -d'=' -f2)
VERSION_CODE=$(grep '^VERSION_CODE=' version.properties | cut -d'=' -f2)

if [ -z "$VERSION_NAME" ] || [ -z "$VERSION_CODE" ]; then
  echo "❌ 无法解析版本号，请检查 version.properties 格式（应包含 VERSION_NAME / VERSION_CODE）"
  exit 1
fi

echo "🔄 更新版本号到 $VERSION_NAME+$VERSION_CODE"

# 更新 pubspec.yaml（保留原文件为 .bak）
OLD_VERSION=$(grep '^version:' pubspec.yaml | head -1)
sed -i.bak "s/^version:.*/version: $VERSION_NAME+$VERSION_CODE/" pubspec.yaml

echo "✅ 已更新 pubspec.yaml: ${OLD_VERSION#version: } → $VERSION_NAME+$VERSION_CODE"
