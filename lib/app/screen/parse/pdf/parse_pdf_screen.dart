import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_controller.dart';

class ParsePdfScreen extends GetView<ParsePdfController> {
  const ParsePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF解析"), leading: BackButton()),
      body: controller.renderPageState.displaySuccess(
        loadingBuilder: () {
          return Center(
            child: TDLoading(
              size: TDLoadingSize.large,
              text: "解析中，根据文件大小所需时间不同",
            ),
          );
        },
        successBuilder: (data) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TDButton(
                  text: "导入",
                  width: double.infinity,
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    controller.importPDF();
                    Get.back();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
