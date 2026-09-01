
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