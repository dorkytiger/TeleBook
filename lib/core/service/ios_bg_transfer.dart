import 'package:flutter/foundation.dart';
import 'package:tele_book/core/util/file_log.dart';
import 'package:flutter/services.dart';

/// 单条后台下载项。
class BgDownloadItem {
  final String url;
  final Map<String, String> headers;
  final String destPath;
  final String hash;
  final String uuid;
  final String relPath;

  const BgDownloadItem({
    required this.url,
    required this.headers,
    required this.destPath,
    required this.hash,
    required this.uuid,
    required this.relPath,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'headers': headers,
        'destPath': destPath,
        'hash': hash,
        'uuid': uuid,
        'relPath': relPath,
      };
}

/// iOS 后台下载桥（原生 URLSession background session）。
///
/// 由 Swift 端 `SyncBackgroundDownloader` 处理：下载交给系统后台传输，
/// 完成后（或失败）通过 `onDownloaded` 回传；App 锁屏/挂起/被回收仍能完成。
///
/// Android 走前台服务保活 + Dio（见 sync_native_service）；本桥仅 iOS。
class IosBgTransfer {
  static const MethodChannel _channel = MethodChannel('telebook/ios_bg_transfer');

  /// 下载完成回调：`(ok, hash, uuid, relPath, destPath, error?)`。
  static void Function(
          bool ok, String hash, String uuid, String relPath, String destPath, String? error)?
      onDownloaded;

  /// 直传完成回调：`(ok, hash, error?)`。
  static void Function(bool ok, String hash, String? error)? onUploaded;

  static bool _configured = false;

  static bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// 注册平台 → Dart 事件（幂等）。
  static void ensureConfigured() {
    if (_configured || !supported) return;
    _configured = true;
    _channel.setMethodCallHandler((call) async {
      final args = call.arguments as Map? ?? const {};
      if (call.method == 'onDownloaded') {
        FileLog.log('BG_EVT', 'onDownloaded ok=${args['ok']} hash=${args['hash']} uuid=${args['uuid']} rel=${args['relPath']} err=${args['error']}');
        onDownloaded?.call(
          args['ok'] == true,
          args['hash'] as String? ?? '',
          args['uuid'] as String? ?? '',
          args['relPath'] as String? ?? '',
          args['destPath'] as String? ?? '',
          args['error'] as String?,
        );
      } else if (call.method == 'onUploaded') {
        FileLog.log('BG_EVT', 'onUploaded ok=${args['ok']} hash=${args['hash']} err=${args['error']}');
        onUploaded?.call(
          args['ok'] == true,
          args['hash'] as String? ?? '',
          args['error'] as String?,
        );
      }
    });
  }

  /// 入队一个后台下载任务。返回是否已成功入队（原生不可用/无宿主返回 false，
  /// 调用方应回退到前台 Dio 下载）。
  static Future<bool> enqueueDownload({
    required String url,
    required Map<String, String> headers,
    required String destPath,
    required String hash,
    required String uuid,
    required String relPath,
  }) async {
    if (!supported) return false;
    ensureConfigured();
    try {
      final ok = await _channel.invokeMethod<bool>('enqueueDownload', {
        'url': url,
        'headers': headers,
        'destPath': destPath,
        'hash': hash,
        'uuid': uuid,
        'relPath': relPath,
      });
      FileLog.log('BG_EVT', 'enqueueDownload -> $ok hash=$hash');
      return ok == true;
    } catch (_) {
      return false; // 无宿主/异常：回退前台下载
    }
  }

  /// 整批入队后台下载。原生内部维护队列（并发有限、完成自动派发下一个），
  /// 因此 App 锁屏/挂起/被杀后整批仍能由系统持续推进。
  /// 返回是否有任务被接受（原生不可用返回 false，调用方回退前台）。
  static Future<bool> enqueueDownloadBatch({
    required List<BgDownloadItem> items,
  }) async {
    if (!supported || items.isEmpty) return false;
    ensureConfigured();
    try {
      final ok = await _channel.invokeMethod<bool>('enqueueDownloadBatch', {
        'items': [for (final it in items) it.toJson()],
      });
      FileLog.log('BG_EVT', 'enqueueDownloadBatch -> $ok items=${items.length}');
      return ok == true;
    } catch (_) {
      return false;
    }
  }

  /// 入队一个后台整文件直传任务（POST 到服务器 direct 接口，body=文件）。
  /// 返回是否已成功入队（原生不可用返回 false，调用方回退分片上传）。
  static Future<bool> uploadFileDirect({
    required String url,
    required Map<String, String> headers,
    required String filePath,
    required String hash,
  }) async {
    if (!supported) return false;
    ensureConfigured();
    try {
      final ok = await _channel.invokeMethod<bool>('enqueueUpload', {
        'url': url,
        'headers': headers,
        'filePath': filePath,
        'hash': hash,
      });
      FileLog.log('BG_EVT', 'enqueueUpload -> $ok hash=$hash');
      return ok == true;
    } catch (_) {
      return false;
    }
  }
}
