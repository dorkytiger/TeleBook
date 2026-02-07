import 'package:dk_util/log/dk_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class UpdateService {
  UpdateService._();

  final _shorebird = ShorebirdUpdater();

  void init() {
    _shorebird.readCurrentPatch().then((currentPatch) {
      if (currentPatch != null) {
        DKLog.d("当前补丁版本: ${currentPatch.number}");
      } else {
        DKLog.d("当前没有补丁版本");
      }
    });
  }

  Future<void> checkForUpdates() async {
    try {
      final status = await _shorebird.checkForUpdate();
      if (status == UpdateStatus.outdated) {
        await _shorebird.update();
        Get.dialog(
          TDAlertDialog(
            title: "应用已更新",
            content: "应用已更新到最新版本，请重启应用以生效。",
            rightBtn: TDDialogButtonOptions(
              title: "重启",
              action: () {
                Restart.restartApp();
              },
            ),
            leftBtn: TDDialogButtonOptions(
              title: "稍后",
              action: () {
                Get.back();
              },
            ),
          ),
        );
      } else {
        DKLog.i("当前已经是最新版本");
      }
    } catch (e, stackTrace) {
      DKLog.e("检查更新出错: $e", error: e, stackTrace: stackTrace);
    }
  }
}
