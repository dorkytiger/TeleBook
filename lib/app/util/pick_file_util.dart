import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class PickFileUtil {
  static Future<FilePickerResult?> pickerFile({
    FileType type = FileType.custom,
    List<String>? allowedExtensions,
  }) async {
    // 只在 Android 平台上申请权限
    if (Platform.isAndroid) {
      // 根据 Android 版本请求不同的权限
      PermissionStatus status;

      // 对于 Android 13+ (API 33+), 使用 READ_MEDIA_* 权限
      // 对于 Android 11-12 (API 30-32), 可能需要 MANAGE_EXTERNAL_STORAGE
      // 对于 Android 10 及以下, 使用传统的 READ_EXTERNAL_STORAGE

      // 先尝试使用存储权限
      status = await Permission.storage.status;

      // 如果权限被永久拒绝，提示用户去设置
      if (status.isPermanentlyDenied) {
        final result = await Get.dialog<bool>(
          TDAlertDialog(
            title: '权限被拒绝',
            content: '需要存储权限来选择文件，请在设置中开启',
            leftBtn: TDDialogButtonOptions(
              title: '取消',
              action: () {
                Get.back(result: false);
              },
            ),
            rightBtn: TDDialogButtonOptions(
              title: '去设置',
              action: () {
                Get.back(result: true);
              },
            ),
          ),
        );
        if (result == true) {
          await openAppSettings();
        }
        return null;
      }

      // 如果权限未授予，申请权限
      if (!status.isGranted) {
        status = await Permission.storage.request();

        // 如果还是没有权限，尝试申请 manageExternalStorage (Android 11+)
        if (!status.isGranted) {
          final manageStatus = await Permission.manageExternalStorage.status;
          if (!manageStatus.isGranted) {
            status = await Permission.manageExternalStorage.request();
          } else {
            status = manageStatus;
          }
        }
      }

      // 再次检查权限状态
      if (status.isGranted) {
        // 权限已授予，执行文件选择操作
        try {
          final result = await FilePicker.platform.pickFiles(
            type: type,
            allowedExtensions: allowedExtensions,
          );
          return result;
        } catch (e) {
          throw Exception('选择文件时出错: $e');
        }
      } else if (status.isDenied) {
        // 权限被拒绝
        throw Exception('存储权限被拒绝，无法选择文件');
      } else if (status.isPermanentlyDenied) {
        // 权限被永久拒绝，提示用户去设置中开启
        final result = await Get.dialog<bool>(
          TDAlertDialog(
            title: '权限被拒绝',
            content: '需要存储权限来选择文件，请在设置中开启',
            leftBtn: TDDialogButtonOptions(
              title: '取消',
              action: () {
                Get.back(result: false);
              },
            ),
            rightBtn: TDDialogButtonOptions(
              title: '去设置',
              action: () {
                Get.back(result: true);
              },
            ),
          ),
        );
        if (result == true) {
          await openAppSettings();
        }
      }
      return null;
    }

    // 桌面平台（Windows、Linux、macOS）和 iOS 不需要申请权限，直接选择文件
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );
      return result;
    } catch (e) {
      throw Exception('选择文件时出错: $e');
    }
  }

  /// 选择文件夹
  static Future<String?> pickDirectory() async {
    // 只在 Android 平台上申请权限
    if (Platform.isAndroid) {
      // 请求存储权限
      PermissionStatus status = await Permission.storage.status;

      // 如果权限被永久拒绝，提示用户去设置
      if (status.isPermanentlyDenied) {
        final result = await Get.dialog<bool>(
          TDAlertDialog(
            title: '权限被拒绝',
            content: '需要存储权限来选择文件夹，请在设置中开启',
            leftBtn: TDDialogButtonOptions(
              title: '取消',
              action: () {
                Get.back(result: false);
              },
            ),
            rightBtn: TDDialogButtonOptions(
              title: '去设置',
              action: () {
                Get.back(result: true);
              },
            ),
          ),
        );
        if (result == true) {
          await openAppSettings();
        }
        return null;
      }

      // 如果权限未授予，申请权限
      if (!status.isGranted) {
        status = await Permission.storage.request();

        // Android 11+ 可能需要额外权限
        if (!status.isGranted) {
          final manageStatus = await Permission.manageExternalStorage.status;
          if (!manageStatus.isGranted) {
            status = await Permission.manageExternalStorage.request();
          } else {
            status = manageStatus;
          }
        }
      }

      // 检查权限状态
      if (status.isGranted) {
        try {
          // 使用 getDirectoryPath 选择文件夹
          final String? selectedDirectory = await FilePicker.platform
              .getDirectoryPath();

          if (selectedDirectory != null) {
            return selectedDirectory;
          }
        } catch (e) {
          throw Exception('选择文件夹时出错: $e');
        }
      } else if (status.isDenied) {
        throw Exception('存储权限被拒绝，无法选择文件夹');
      } else if (status.isPermanentlyDenied) {
        final result = await Get.dialog<bool>(
          TDAlertDialog(
            title: '权限被拒绝',
            content: '需要存储权限来选择文件夹，请在设置中开启',
            leftBtn: TDDialogButtonOptions(
              title: '取消',
              action: () {
                Get.back(result: false);
              },
            ),
            rightBtn: TDDialogButtonOptions(
              title: '去设置',
              action: () {
                Get.back(result: true);
              },
            ),
          ),
        );
        if (result == true) {
          await openAppSettings();
        }
      }
      return null;
    }

    // 桌面平台（Windows、Linux、macOS）和 iOS 不需要申请权限，直接选择文件夹
    try {
      final String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath();
      return selectedDirectory;
    } catch (e) {
      throw Exception('选择文件夹时出错: $e');
    }
  }
}
