import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/service/toast_service.dart';

class ExportController extends GetxController {
  final exportService = Get.find<ExportService>();

  List<ExportRecord> get records => exportService.records;

  @override
  void refresh() {
    // nothing for now; records is observable
    update();
  }

  /// Open the exported file or reveal it in the system file manager when supported.
  Future<void> openExport(ExportRecord record) async {
    final path = record.outputPath;
    if (path == null) {
      ToastService.showError('错误,导出路径为空');
      return;
    }

    try {
      // Always try to open the folder (directory) first, regardless of platform
      final folder = File(path).parent.path;
      OpenResult result = await OpenFilex.open(folder);

      // Handle different result types
      if (result.type == ResultType.done) {
        ToastService.showSuccess('已在文件管理器中打开');
      } else if (result.type == ResultType.fileNotFound) {
        ToastService.showError('文件夹不存在: $folder');
      } else if (result.type == ResultType.noAppToOpen) {
        // Folder can't be opened, try opening the file as fallback
        ToastService.showText('无法打开文件夹，尝试打开文件');
        result = await OpenFilex.open(path);

        if (result.type == ResultType.done) {
          ToastService.showSuccess('已打开文件');
        } else {
          ToastService.showError('无法打开文件，请使用"分享"功能\n路径: $path');
        }
      } else if (result.type == ResultType.permissionDenied) {
        // Handle permission denied: request permission first
        if (Platform.isAndroid) {
          final hasPermission = await _requestStoragePermission();
          if (hasPermission) {
            // Permission granted, retry opening folder
            final retryResult = await OpenFilex.open(folder);
            if (retryResult.type == ResultType.done) {
              ToastService.showSuccess('已在文件管理器中打开');
            } else if (retryResult.type == ResultType.noAppToOpen) {
              // Folder still can't be opened, try file
              final fileResult = await OpenFilex.open(path);
              if (fileResult.type == ResultType.done) {
                ToastService.showSuccess('已打开文件');
              } else {
                ToastService.showText('无法直接打开，请使用"分享"功能');
              }
            } else {
              // Still can't open
              ToastService.showText('无法打开文件夹，请使用"分享"功能');
            }
          } else {
            // Permission denied
            ToastService.showText('需要存储权限才能打开，请使用"分享"功能或授予权限');
          }
        } else {
          ToastService.showError('没有权限访问该文件夹');
        }
      } else {
        ToastService.showError('无法打开文件夹: ${result.message}');
      }
    } catch (e) {
      ToastService.showError('打开时出错: $e\n路径: $path');
    }
  }

  /// Request storage permission for Android
  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // Android 13+ (API 33+) uses granular media permissions
      // For accessing external storage files, we need manageExternalStorage
      // or use SAF (Storage Access Framework)

      // For Android 11+ (API 30+), try manageExternalStorage first
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Try to request manageExternalStorage
      var status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        // Guide user to app settings
        final shouldOpenSettings =
            await Get.dialog<bool>(
              AlertDialog(
                title: Text('需要存储权限'),
                content: Text(
                  '为了打开导出的文件，需要授予存储权限。\n\n您可以：\n1. 在设置中授予权限后重试\n2. 使用"分享"功能打开文件',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text('去设置'),
                  ),
                ],
              ),
              barrierDismissible: false,
            ) ??
            false;

        if (shouldOpenSettings) {
          await openAppSettings();
          // Wait a bit and check again
          await Future.delayed(Duration(seconds: 1));
          return await Permission.manageExternalStorage.isGranted;
        }
      }

      // Fallback to basic storage permission for older Android versions
      if (await Permission.storage.isGranted) {
        return true;
      }

      status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Share the exported file using the system share sheet
  Future<void> _shareFile(String path) async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: '分享自 TeleBook'),
      );

      if (result.status == ShareResultStatus.success) {
        ToastService.showSuccess('分享成功');
      } else if (result.status == ShareResultStatus.dismissed) {
        ToastService.showText('分享已取消');
      }
    } catch (e) {
      ToastService.showError('分享失败: $e');
    }
  }

  /// Directly share the exported file (can be called from UI)
  Future<void> shareExport(ExportRecord record) async {
    final path = record.outputPath;
    if (path == null) {
      ToastService.showError('错误,导出路径为空');
      return;
    }

    await _shareFile(path);
  }
}
