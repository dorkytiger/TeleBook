import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/service/toast_service.dart';

/// 错误日志详情页面
class ErrorLogScreen extends StatelessWidget {
  final String title;
  final String message;
  final DateTime timestamp;

  const ErrorLogScreen({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: title,
        rightBarItems: [
          TDNavBarItem(icon: Icons.copy, action: () => _copyToClipboard()),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间戳
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 错误信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 复制按钮
            SizedBox(
              width: double.infinity,
              child: TDButton(
                text: '复制错误信息',
                icon: Icons.copy,
                size: TDButtonSize.large,
                type: TDButtonType.outline,
                onTap: _copyToClipboard,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard() {
    final fullText = '$title\n\n时间: ${_formatTimestamp(timestamp)}\n\n$message';
    Clipboard.setData(ClipboardData(text: fullText));
    ToastService.showSuccess('已复制到剪贴板');
  }

  /// 静态方法：显示错误日志详情页面
  static void show({
    required String title,
    required String message,
    DateTime? timestamp,
  }) {
    Get.to(
      () => ErrorLogScreen(
        title: title,
        message: message,
        timestamp: timestamp ?? DateTime.now(),
      ),
      transition: Transition.cupertino,
    );
  }
}
