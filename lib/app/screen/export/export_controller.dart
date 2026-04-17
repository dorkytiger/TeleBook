import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tele_book/app/store/export_store.dart';

class ExportController extends ChangeNotifier {
  final ExportStore exportStore;

  List<ExportRecord> get records => exportStore.records;

  ExportController({required this.exportStore}) {
    exportStore.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => notifyListeners();

  /// Open the exported file or reveal it in the system file manager when supported.
  Future<void> openExport(ExportRecord record) async {
    final path = record.outputPath;
    if (path == null) {
      return;
    }

    try {
      // Always try to open the folder (directory) first, regardless of platform
      final folder = File(path).parent.path;
      OpenResult result = await OpenFilex.open(folder);

      // Handle different result types
      if (result.type == ResultType.done) {

      } else if (result.type == ResultType.fileNotFound) {

      } else if (result.type == ResultType.noAppToOpen) {

        result = await OpenFilex.open(path);

        if (result.type == ResultType.done) {

        } else {

        }
      } else if (result.type == ResultType.permissionDenied) {
        // Handle permission denied: request permission first
        if (Platform.isAndroid) {
          final hasPermission = await _requestStoragePermission();
          if (hasPermission) {
            // Permission granted, retry opening folder
            final retryResult = await OpenFilex.open(folder);
            if (retryResult.type == ResultType.done) {

            } else if (retryResult.type == ResultType.noAppToOpen) {
              // Folder still can't be opened, try file
              final fileResult = await OpenFilex.open(path);
              if (fileResult.type == ResultType.done) {

              } else {

              }
            } else {

            }
          } else {

          }
        } else {

        }
      } else {

      }
    } catch (e) {

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
        await openAppSettings();
        await Future.delayed(const Duration(seconds: 1));
        return await Permission.manageExternalStorage.isGranted;
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
  Future<void> shareExport(ExportRecord record) async {
    final path = record.outputPath;
    if (path == null) return;
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: '分享自 TeleBook'),
      );
    } catch (_) {}
  }

  /// Retry exporting the book associated with the record
  Future<void> retryExport(ExportRecord record) async {
    if (record.bookId == null) return;
    await exportStore.exportBookById(record.bookId!);
  }

  @override
  void dispose() {
    exportStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}
