import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_controller.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';

class ParsePdfScreen extends GetView<ParsePdfController> {
  const ParsePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "解析PDF",
        // 顶部右上角保存按钮
        rightBarItems: [
          TDNavBarItem(
            iconWidget: Obx(
              () => controller.renderPageState.value.isSuccess()
                  ? TDButton(
                      icon: Icons.save,
                      type: TDButtonType.text,
                      size: TDButtonSize.small,
                      onTap: () {
                        controller.saveImagesToLocal();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
      body: Obx(
        () => DisplayResult(
          state: controller.renderPageState.value,
          onLoading: () {
            return const Center(
              child: TDLoading(
                size: TDLoadingSize.large,
                text: "解析中，根据文件大小所需时间不同",
              ),
            );
          },
          onSuccess: (data) {
            return ListView.builder(
              itemCount: data.where((e) => e != null).length,
              itemBuilder: (context, index) {
                final item = data[index];
                return item != null
                    ? SizedBox(
                        width: double.infinity,
                        child: Image.memory(item, fit: BoxFit.contain),
                      )
                    : const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
