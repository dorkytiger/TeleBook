import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_controller.dart';

class BookFormScreen extends GetView<BookFormController> {
  const BookFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加数据'),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("选择导入源", style: Theme.of(context).textTheme.titleMedium),
                _buildSourceSelection(context),
                Text("输入信息", style: Theme.of(context).textTheme.titleMedium),
                _buildForm(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            label: Text("提交"),
            onPressed: () {
              controller.submitForm();
            },
            icon: Icon(Icons.check),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSelection(BuildContext context) {
    return Column(
      children: [
        RadioGroup<BookFormSources>(
          onChanged: (value) {
            controller.source.value = value!;
          },
          groupValue: controller.source.value,
          child: Column(
            children: [
              RadioListTile(
                value: BookFormSources.web,

                selected: controller.source.value == BookFormSources.web,
                title: Text("来自网页"),
                subtitle: Text("从网页解析后,下载书籍到本地"),
              ),
              RadioListTile(
                value: BookFormSources.archive,
                selected: controller.source.value == BookFormSources.archive,
                title: Text("来自压缩包"),
                subtitle: Text("从压缩包中提取书籍到本地"),
              ),
              RadioListTile(
                value: BookFormSources.batchArchive,
                selected:
                    controller.source.value == BookFormSources.batchArchive,
                title: Text("来自批量压缩包"),
                subtitle: Text("选择文件夹,从文件夹里面多个压缩包中提取书籍到本地"),
              ),
              RadioListTile(
                value: BookFormSources.pdf,
                selected: controller.source.value == BookFormSources.pdf,
                title: Text("来自PDF文件"),
                subtitle: Text("从PDF文件中提取书籍到本地"),
              ),
              RadioListTile(
                value: BookFormSources.imageFolder,
                selected:
                    controller.source.value == BookFormSources.imageFolder,
                title: Text("来自图片文件夹"),
                subtitle: Text("从图片文件夹中提取书籍到本地"),
              ),
              RadioListTile(
                value: BookFormSources.batchImageFolder,
                selected:
                    controller.source.value == BookFormSources.batchImageFolder,
                title: Text("来自批量图片文件夹"),
                subtitle: Text("选择文件夹,从文件夹里面多个图片文件夹中提取书籍到本地"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    switch (controller.source.value) {
      case BookFormSources.web:
        return TextField(
          controller: controller.webUrlController,
          decoration: InputDecoration(
            labelText: "网页地址",
            hintText: "请输入网页地址",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pasteFromClipboard(context);
              },
              label: Text('粘贴'),
              icon: Icon(Icons.paste),
            ),
          ),
          autofocus: false,
        );
      case BookFormSources.archive:
        return TextField(
          controller: controller.filePathController,
          decoration: InputDecoration(
            labelText: "压缩包文件",
            hintText: "请选择压缩包文件",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pickArchiveFile();
              },
              label: Text("选择文件"),
              icon: Icon(Icons.folder_open),
            ),
          ),
          readOnly: true,
        );
      case BookFormSources.batchArchive:
        return TextField(
          controller: controller.folderPathController,
          decoration: InputDecoration(
            labelText: "压缩包文件夹",
            hintText: "请选择包含压缩包的文件夹",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pickFolder();
              },
              label: Text("选择文件夹"),
              icon: Icon(Icons.folder_open),
            ),
          ),
          readOnly: true,
        );
      case BookFormSources.pdf:
        return TextField(
          controller: controller.pdfPathController,
          decoration: InputDecoration(
            labelText: "PDF文件",
            hintText: "请选择PDF文件",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pickPdf();
              },
              label: Text("选择文件"),
              icon: Icon(Icons.folder_open),
            ),
          ),
          readOnly: true,
        );
      case BookFormSources.imageFolder:
        return TextField(
          controller: controller.imageFolderPathController,
          decoration: InputDecoration(
            labelText: "图片文件夹",
            hintText: "请选择图片文件夹",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pickImageFolder();
              },
              label: Text("选择文件夹"),
              icon: Icon(Icons.folder_open),
            ),
          ),
          readOnly: true,
        );
      case BookFormSources.batchImageFolder:
        return TextField(
          controller: controller.batchImageFolderPathController,
          decoration: InputDecoration(
            labelText: "图片文件夹",
            hintText: "请选择包含图片文件夹的文件夹",
            border: OutlineInputBorder(),
            suffixIcon: FilledButton.icon(
              onPressed: () {
                controller.pickBatchImageFolder();
              },
              label: Text("选择文件夹"),
              icon: Icon(Icons.folder_open),
            ),
          ),
          readOnly: true,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
