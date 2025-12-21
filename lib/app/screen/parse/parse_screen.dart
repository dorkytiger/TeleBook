import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/parse_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParseScreen extends GetView<ParseController> {
  const ParseScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TDNavBar(
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.refresh,
            action: (){
              controller.webViewController.reload();
            }
          ),
        ],
      ),
      body: Material(
        child: WebViewWidget(controller: controller.webViewController),
      ),
    );
  }
}
