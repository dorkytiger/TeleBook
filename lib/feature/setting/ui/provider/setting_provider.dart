
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/feature/setting/enum/setting_key_value.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';

part 'setting_provider.g.dart';

@Riverpod(keepAlive: true)
class ReadingDirectionSetting extends _$ReadingDirectionSetting {
  @override
  Future<ReadingDirection> build() async {
    final repo = ref.watch(settingRepositoryProvider);
    return repo.getReadingDirection();
  }

  /// 修改阅读顺序：写库 + 直接更新内存状态（UI 立即响应，不用重新查库）
  Future<void> set(ReadingDirection dir) async {
    await ref.read(settingRepositoryProvider).setReadingDirection(dir);
    state = AsyncData(dir);
  }
}

/// 是否已初始化服务器（保存了 url + token）。
///
/// 响应 setting 表变更：在引导页连接成功写库后，设置页无需手动刷新
/// 即从「初始化服务器」切换为「重新初始化服务器 + 同步功能」。
final syncConfiguredProvider = StreamProvider.autoDispose<bool>((ref) {
  return ref.watch(settingRepositoryProvider).watchConfigured();
});
