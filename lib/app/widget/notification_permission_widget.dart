import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/service/download_service.dart';

/// 通知权限检查组件
class NotificationPermissionWidget extends StatelessWidget {
  const NotificationPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadService = Get.find<DownloadService>();

    return FutureBuilder<bool>(
      future: downloadService.checkNotificationPermission(),
      builder: (context, snapshot) {
        // 加载中
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        // 已有权限，不显示提示
        if (snapshot.data == true) {
          return const SizedBox.shrink();
        }

        // 没有权限，显示提示卡片
        return Container(
          margin: const EdgeInsets.all(16),
          child: TDNoticeBar(
            left: Icon(
              Icons.notifications_off,
              color: TDTheme.of(context).warningColor5,
            ),
            content: '未授予通知权限，无法显示下载进度通知',
            right: TDButton(
              text: '去设置',
              size: TDButtonSize.small,
              type: TDButtonType.text,
              theme: TDButtonTheme.primary,
              onTap: () async {
                await downloadService.openNotificationSettings();
              },
            ),
            context: context,
          ),
        );
      },
    );
  }
}

