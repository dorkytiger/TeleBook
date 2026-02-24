import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_controller.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

class ParsePdfScreen extends GetView<ParsePdfController> {
  const ParsePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF解析"), leading: BackButton()),
      body: controller.renderPageState.displaySuccess(
        loadingBuilder: () {
          return Center(child: CustomLoading());
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
                        ? ListTile(
                            title: Text("第${index + 1}页"),
                            subtitle: Text(
                              "大小: ${(item.elementSizeInBytes).toStringAsFixed(2)} KB",
                            ),
                            leading: Image.memory(item, fit: BoxFit.cover),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    controller.importPDF();
                  },
                  icon: Icon(Icons.save),
                  label: Text("保存图片"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
