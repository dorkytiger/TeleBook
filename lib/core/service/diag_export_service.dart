import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/core/util/crash_guard.dart';

/// 诊断包导出（崩溃排查）：把统一日志 + 崩溃记录 + 上下文信息
/// 打包成 zip，通过系统分享面板发出（微信/邮件/存文件等）。
///
/// 包内容：
/// - context.txt：设备/版本/平台/服务器（脱敏）等静态信息；
/// - logs/ 下所有主日志滚动文件 + crash_*.log 崩溃记录。
abstract final class DiagExport {
  /// 打包并分享诊断包。返回是否成功弹出分享面板。
  /// [onProgress]（可选）：0.0 打包中 → 1.0 完成，UI 显示进度用。
  static Future<bool> share({
    void Function(double progress)? onProgress,
  }) async {
    try {
      // 1. 等待日志落盘积压写完（flush 是异步的）
      onProgress?.call(0.05);
      await Future.delayed(const Duration(milliseconds: 300));

      // 2. 收集上下文 + 日志文件
      onProgress?.call(0.2);
      final context = await CrashGuard.contextText();
      final archive = Archive();
      archive.addFile(
        ArchiveFile.string('context.txt', context),
      );

      // 主日志（新 → 旧都带上，时间序完整）
      final mainLogs = await AppLog.readTail(tail: 100000);
      if (mainLogs.isNotEmpty) {
        archive.addFile(
          ArchiveFile.string('logs/app.log', '${mainLogs.join('\n')}\n'),
        );
      }

      // 崩溃记录
      final crashes = await AppLog.crashFiles();
      for (var i = 0; i < crashes.length; i++) {
        final f = crashes[i];
        try {
          final bytes = await f.readAsBytes();
          if (bytes.length > 4 * 1024 * 1024) continue; // 单条过大跳过
          archive.addFile(
            ArchiveFile.bytes('logs/${p.basename(f.path)}', bytes),
          );
        } catch (_) {}
        onProgress?.call(0.3 + 0.5 * ((i + 1) / crashes.length));
      }

      // 3. zip 编码写临时文件
      onProgress?.call(0.85);
      final out = File(
        p.join(
          GlobalConfig.appTempDir.path,
          'telebook_diag_${DateTime.now().millisecondsSinceEpoch}.zip',
        ),
      );
      final zipBytes = ZipEncoder().encodeBytes(archive);
      await out.writeAsBytes(zipBytes, flush: true);

      // 4. 系统分享面板
      onProgress?.call(1.0);
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(out.path, mimeType: 'application/zip')],
          subject: 'TeleBook 诊断日志',
          text: 'TeleBook 诊断日志包（含设备信息与崩溃记录）',
        ),
      );
      // 分享完成后清理临时 zip（系统已复制走）
      try {
        await out.delete();
      } catch (_) {}
      return result.status != ShareResultStatus.unavailable;
    } catch (e) {
      AppLog.e('导出诊断包失败: $e', tag: 'DIAG');
      return false;
    }
  }
}
