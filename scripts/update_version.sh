#!/bin/bash

# 读取版本号
VERSION=$(grep '^version=' version.properties | cut -d'=' -f2)
BUILD_NUMBER=$(grep '^build_number=' version.properties | cut -d'=' -f2)

echo "Updating version to $VERSION+$BUILD_NUMBER"

# 更新 pubspec.yaml
sed -i.bak "s/^version:.*/version: $VERSION+$BUILD_NUMBER/" pubspec.yaml

echo "✅ Version updated successfully!"
echo "pubspec.yaml: version: $VERSION+$BUILD_NUMBER"

