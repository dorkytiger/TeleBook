import 'package:tele_book/core/service/sync_service.dart';

/// 单本书的匹配结论（§2.1.4）。
enum BookMatchKind {
  // 本地有 uuid、远程有同 uuid 且文件 hash 完全一致 → 不动
  same,
  // 本地有 uuid、远程有同 uuid 但文件 hash 不一致 → 冲突（用户选保留本地/服务器）
  conflict,
  // 远程有、本地无同 uuid → 需下载
  download,
  // 本地有、远程无同 uuid → 需上传
  upload,
}

/// 匹配结果：一本远程书 + 结论。
class BookMatch {
  final RemoteLibraryBook remote; // 远程书（download/conflict 时用于下载/对比）
  final BookMatchKind kind;

  const BookMatch({required this.remote, required this.kind});
}

/// 匹配计划：三类动作清单。
class MatchPlan {
  final List<RemoteLibraryBook> toDownload; // 远程有本地无 → 下载
  final List<RemoteLibraryBook> conflicts; // 同 uuid 但 hash 不一致 → 冲突
  final List<String> toUploadUuids; // 本地有远程无 → 上传（本地 uuid）
  final int skipped; // 同 uuid 且 hash 一致 → 跳过数

  const MatchPlan({
    this.toDownload = const [],
    this.conflicts = const [],
    this.toUploadUuids = const [],
    this.skipped = 0,
  });
}

/// 本地书摘要（uuid + 文件 hash 集合），匹配用。
class LocalBookDigest {
  final String uuid;
  final String name;
  final Set<String> fileHashes; // 该书全部文件 hash

  const LocalBookDigest({
    required this.uuid,
    required this.name,
    required this.fileHashes,
  });
}

/// 纯函数：由本地书摘要 + 远程书清单构建匹配计划（可单测，§2.1.4）。
///
/// - uuid 相同且文件 hash 集合相同 → same（跳过）
/// - uuid 相同但 hash 集合不同 → conflict
/// - 远程有本地无 → download
/// - 本地有远程无 → upload
MatchPlan buildMatchPlan(
  List<LocalBookDigest> localBooks,
  List<RemoteLibraryBook> remoteBooks,
) {
  final remoteByUuid = {for (final r in remoteBooks) r.uuid: r};
  final localByUuid = {for (final l in localBooks) l.uuid: l};

  final toDownload = <RemoteLibraryBook>[];
  final conflicts = <RemoteLibraryBook>[];
  var skipped = 0;
  final localHandled = <String>{};

  // ① 遍历远程书：匹配本地
  for (final r in remoteBooks) {
    final local = localByUuid[r.uuid];
    if (local == null) {
      toDownload.add(r); // 远程有本地无 → 下载
      continue;
    }
    localHandled.add(r.uuid);
    final remoteHashes = {for (final f in r.files) f.hash};
    // 文件 hash 集合相同（数量 + 内容都一致）→ 同本
    if (_sameFiles(local.fileHashes, remoteHashes)) {
      skipped++;
    } else {
      conflicts.add(r); // 同 uuid 但文件不同 → 冲突
    }
  }

  // ② 遍历本地书：远程无同 uuid → 上传
  final toUploadUuids = <String>[];
  for (final l in localBooks) {
    if (!remoteByUuid.containsKey(l.uuid)) {
      toUploadUuids.add(l.uuid);
    }
  }

  return MatchPlan(
    toDownload: toDownload,
    conflicts: conflicts,
    toUploadUuids: toUploadUuids,
    skipped: skipped,
  );
}

bool _sameFiles(Set<String> a, Set<String> b) {
  if (a.length != b.length) return false;
  for (final h in a) {
    if (!b.contains(h)) return false;
  }
  return true;
}
