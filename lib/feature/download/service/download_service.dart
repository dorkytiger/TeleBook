import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/download/enum/download_status.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';
import 'package:tele_book/feature/download/repository/download_repository.dart';
import 'package:uuid/uuid.dart';

class DownloadService {
  final FileDownloader _downloader = FileDownloader();
  final DownloadRepository _downloadRepository;
  final BookRepository _bookRepository;
  final Lock _stateLock = Lock();
  final Set<String> _autoSavedGroups = {};

  DownloadService(this._downloadRepository, this._bookRepository);

  Stream<List<DownloadTaskVO>> watchDownloadTasks() {
    return _downloadRepository.watchDownloadList();
  }

  Future<void> startDownload(List<String> urls, String title) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final groupId = Uuid().v4();
      var successCount = 0;
      var errorCount = 0;
      final downloadGroup = DownloadGroupBo(
        id: groupId,
        name: title,
        totalCount: urls.length,
        errorCount: 0,
        successCount: 0,
        // Keep an absolute source path for later copy-to-book.
        saveParentPath: "${tempDir.path}/$groupId",
        status: DownloadStatus.pending,
      );
      _downloadRepository.upsertGroup(downloadGroup);
      final downloadItems = <DownloadItemBo>[];
      final itemStateMap = <String, DownloadItemBo>{};
      for (var index = 0; index < urls.length; index++) {
        final url = urls[index];
        final saveSubPath = index.toString().padLeft(7, '0');
        final item = DownloadItemBo(
          id: Uuid().v4(),
          groupId: groupId,
          url: url,
          progress: 0,
          saveSubPath: saveSubPath,
          status: DownloadStatus.pending,
          order: index,
        );
        downloadItems.add(item);
        itemStateMap[item.id] = item;
        _downloadRepository.upsertItem(item);
      }

      void emitGroupStatus() {
        final completeCount = successCount + errorCount;
        final groupStatus = completeCount >= urls.length
            ? (errorCount > 0
                  ? DownloadStatus.failed
                  : DownloadStatus.completed)
            : DownloadStatus.downloading;
        _downloadRepository.upsertGroup(
          downloadGroup.copyWith(
            successCount: successCount,
            errorCount: errorCount,
            status: groupStatus,
          ),
        );
      }
      for (var item in downloadItems) {
        _downloader.download(
          DownloadTask(
            url: item.url,
            filename: item.saveSubPath,
            // `directory` is relative under `baseDirectory`.
            directory: groupId,
            baseDirectory: BaseDirectory.temporary,
          ),
          onProgress: (progress) async {
            await _stateLock.synchronized(() {
              final current = itemStateMap[item.id] ?? item;
              final next = current.copyWith(
                progress: progress,
                status: DownloadStatus.downloading,
              );
              itemStateMap[item.id] = next;
              _downloadRepository.upsertItem(next);
            });
          },
          onStatus: (status) async {
            await _stateLock.synchronized(() {
              final current = itemStateMap[item.id] ?? item;
              switch (status) {
                case TaskStatus.failed:
                  if (current.status != DownloadStatus.failed) {
                    errorCount += 1;
                  }
                  final failedItem = current.copyWith(
                    status: DownloadStatus.failed,
                  );
                  itemStateMap[item.id] = failedItem;
                  _downloadRepository.upsertItem(failedItem);
                  emitGroupStatus();
                  break;
                case TaskStatus.complete:
                  if (current.status != DownloadStatus.completed) {
                    successCount += 1;
                  }
                  final completedItem = current.copyWith(
                    status: DownloadStatus.completed,
                    progress: 1,
                  );
                  itemStateMap[item.id] = completedItem;
                  _downloadRepository.upsertItem(completedItem);
                  emitGroupStatus();
                  break;
                case TaskStatus.running || TaskStatus.enqueued:
                  final downloadingItem = current.copyWith(
                    status: DownloadStatus.downloading,
                  );
                  itemStateMap[item.id] = downloadingItem;
                  _downloadRepository.upsertItem(downloadingItem);
                  emitGroupStatus();
                  break;
                default:
              }
            });
            // 在 lock 外检查是否满足自动保存条件
            await _checkAndAutoSave(groupId);
          },
        );
      }
    } catch (e) {
      throw Exception('下载失败: $e');
    }
  }

  Future<void> retryGroup(String groupId) async {
    final group = _downloadRepository.getDownloadGroup(groupId);
    if (group == null) return;
    final items = _downloadRepository.getDownloadItemsByGroup(groupId);
    if (items.isEmpty) return;

    for (var item in items) {
      if (item.status == DownloadStatus.failed) {
        await retryTask(item.id);
      }
    }
  }

  Future<void> retryTask(String itemId) async {
    final item = _downloadRepository.getDownloadTask(itemId);
    if (item == null) return;
    final group = _downloadRepository.getDownloadGroup(item.groupId);
    if (group == null) return;

    var currentItem = item;


    // 重试时，重置该项状态为下载中，组状态也改为下载中
    final retryingItem = item.copyWith(
      progress: 0,
      status: DownloadStatus.downloading,
    );
    currentItem = retryingItem;
    _downloadRepository.upsertItem(retryingItem);
    _downloadRepository.upsertGroup(
      group.copyWith(status: DownloadStatus.downloading),
    );

    _downloader.download(
      DownloadTask(
        url: item.url,
        filename: item.saveSubPath,
        directory: group.id,
        baseDirectory: BaseDirectory.temporary,
      ),
      onProgress: (progress) async {
        await _stateLock.synchronized(() {
          final next = currentItem.copyWith(
            progress: progress,
            status: DownloadStatus.downloading,
          );
          currentItem = next;
          _downloadRepository.upsertItem(next);
        });
      },
      onStatus: (status) async {
        String? groupIdToUpdate;
        await _stateLock.synchronized(() {
          switch (status) {
            case TaskStatus.failed:
              final failedItem =
                  currentItem.copyWith(status: DownloadStatus.failed);
              currentItem = failedItem;
              _downloadRepository.upsertItem(failedItem);

              groupIdToUpdate = item.groupId;
              break;
            case TaskStatus.complete:
              final completedItem = currentItem.copyWith(
                status: DownloadStatus.completed,
                progress: 1,
              );
              currentItem = completedItem;
              _downloadRepository.upsertItem(completedItem);
              groupIdToUpdate = item.groupId;
              break;
            case TaskStatus.running || TaskStatus.enqueued:
              final downloadingItem = currentItem.copyWith(
                status: DownloadStatus.downloading,
              );
              currentItem = downloadingItem;
              _downloadRepository.upsertItem(downloadingItem);
              break;
            default:
          }
        });
        // 在 lock 外更新组状态和检查自动保存条件
        if (groupIdToUpdate != null) {
          await _updateGroupStatus(groupIdToUpdate!);
        }
        await _checkAndAutoSave(item.groupId);
      },
    );
  }

  /// 根据组内所有项的状态更新组状态
  Future<void> _updateGroupStatus(String groupId) async {
    final group = _downloadRepository.getDownloadGroup(groupId);
    if (group == null) return;

    // 直接读取仓库中的当前快照，避免 stream.first 时序带来的状态回读延迟
    final items = _downloadRepository.getDownloadItemsByGroup(groupId);
    if (items.isEmpty) return;

    // 统计各状态的任务数
    final completedCount = items.where((i) => i.status == DownloadStatus.completed).length;
    final failedCount = items.where((i) => i.status == DownloadStatus.failed).length;
    final downloadingCount = items.where((i) => i.status == DownloadStatus.downloading).length;

    DownloadStatus newStatus = DownloadStatus.pending;

    // 判断新状态
    if (downloadingCount > 0) {
      // 有任务在下载
      newStatus = DownloadStatus.downloading;
    } else if (completedCount + failedCount == items.length) {
      // 全部完成（完成+失败的总和等于总数）
      if (failedCount > 0) {
        newStatus = DownloadStatus.failed;
      } else {
        newStatus = DownloadStatus.completed;
      }
    } else {
      newStatus = DownloadStatus.downloading;
    }

    _downloadRepository.upsertGroup(
      group.copyWith(
        successCount: completedCount,
        errorCount: failedCount,
        status: newStatus,
      ),
    );
  }


  /// 检查组是否已完成且无失败，若满足则自动保存为书籍
  Future<void> _checkAndAutoSave(String groupId) async {
    // 避免重复保存同一组
    if (_autoSavedGroups.contains(groupId)) {
      return;
    }

    final group = _downloadRepository.getDownloadGroup(groupId);
    if (group == null) return;
    final items = _downloadRepository.getDownloadItemsByGroup(groupId);

    // 检查是否满足自动保存条件：全部完成且无失败
    if (group.status == DownloadStatus.completed &&
        group.errorCount == 0 &&
        items.isNotEmpty) {
      _autoSavedGroups.add(groupId);
      // 按 order 排序后再保存
      final sortedItems = List<DownloadItemBo>.from(items)
        ..sort((a, b) => a.order.compareTo(b.order));
      await _bookRepository.saveToBook(
        sortedItems
            .map((e) => "${group.saveParentPath}/${e.saveSubPath}")
            .toList(),
        group.name,
      );
    }
  }
}
