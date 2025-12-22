import 'dart:io';

void main() {
  print('🔄 开始更新版本号...');

  // 读取 version.properties
  final versionFile = File('version.properties');
  if (!versionFile.existsSync()) {
    print('❌ version.properties 文件不存在');
    exit(1);
  }

  final content = versionFile.readAsStringSync();
  final versionNameMatch = RegExp(r'VERSION_NAME=([\d.]+)').firstMatch(content);
  final versionCodeMatch = RegExp(r'VERSION_CODE=(\d+)').firstMatch(content);

  if (versionNameMatch == null || versionCodeMatch == null) {
    print('❌ 无法解析版本号，请检查 version.properties 格式');
    exit(1);
  }

  final versionName = versionNameMatch.group(1)!;
  final versionCode = versionCodeMatch.group(1)!;

  print('📦 读取到版本号: $versionName+$versionCode');

  // 更新 pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml 文件不存在');
    exit(1);
  }

  var pubspecContent = pubspecFile.readAsStringSync();
  final oldVersionMatch = RegExp(r'version:\s*([\d.]+\+\d+|null\+null)').firstMatch(pubspecContent);

  if (oldVersionMatch != null) {
    final oldVersion = oldVersionMatch.group(1);
    pubspecContent = pubspecContent.replaceFirst(
      RegExp(r'version:\s*([\d.]+\+\d+|null\+null)'),
      'version: $versionName+$versionCode',
    );
    pubspecFile.writeAsStringSync(pubspecContent);
    print('✅ 已更新 pubspec.yaml: $oldVersion → $versionName+$versionCode');
  } else {
    print('❌ 无法在 pubspec.yaml 中找到版本号');
    exit(1);
  }

  print('✨ 版本号更新完成！');
}

