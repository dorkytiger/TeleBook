import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';

/// 本地匹配发现的冲突项（§2.1.4：同 uuid 但文件 hash 不同）。
class LocalConflict {
  final String uuid;
  final String name;
  final RemoteLibraryBook serverBook; // 服务器版本（保留服务器时下载它）

  const LocalConflict({
    required this.uuid,
    required this.name,
    required this.serverBook,
  });
}

/// 双向同步匹配出的冲突：收集后由 UI 弹层逐个处理（保留服务器/本地）。
/// 解决动作（下载/上传）由调用方执行；本服务只维护"待处理冲突"状态。
class LocalConflictService {
  /// 待处理冲突（uuid → 冲突），底栏/入口据此显示"存在冲突 N"。
  final ValueNotifier<List<LocalConflict>> pending =
      ValueNotifier(const []);

  /// 双向同步匹配时加入冲突（幂等：同 uuid 覆盖）。
  void add(LocalConflict c) {
    final list = List<LocalConflict>.of(pending.value)
      ..removeWhere((x) => x.uuid == c.uuid)
      ..add(c);
    pending.value = list;
  }

  /// 解决后移除。
  void resolve(String uuid) {
    pending.value =
        pending.value.where((c) => c.uuid != uuid).toList();
  }
}

final localConflictServiceProvider =
    Provider<LocalConflictService>((ref) => LocalConflictService());
