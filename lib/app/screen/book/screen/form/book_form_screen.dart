import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              controller.submitForm();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildSourceDialog(context), _buildForm(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceDialog(BuildContext context) {
    return TextField(
      controller: controller.sourceController,
      decoration: InputDecoration(
        labelText: "导入源",
        hintText: "请选择导入源",
        fillColor: Colors.transparent,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.source),
        suffixIcon: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false,
                  maxChildSize: 0.9,
                  initialChildSize: 0.7,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: _buildSourceSelection(context),
                    );
                  },
                );
              },
            );
          },
          child: Text('选择'),
        ),
      ),
      readOnly: true,
    );
  }

  Widget _buildSourceSelection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "选择导入源",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.check),
            ),
          ],
        ),
        Obx(
          () => RadioGroup<BookFormSources>(
            onChanged: (value) {
              controller.source.value = value!;
              controller.sourceController.text = value.desc;
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
                      controller.source.value ==
                      BookFormSources.batchImageFolder,
                  title: Text("来自批量图片文件夹"),
                  subtitle: Text("选择文件夹,从文件夹里面多个图片文件夹中提取书籍到本地"),
                ),
              ],
            ),
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
            prefixIcon: Icon(Icons.link),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pasteFromClipboard(context);
              },
              child: Text('粘贴'),
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
            prefixIcon: Icon(Icons.archive),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pickArchiveFile();
              },
              child: Text("选择文件"),
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
            prefixIcon: Icon(Icons.folder),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pickFolder();
              },
              child: Text("选择文件夹"),
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
            prefixIcon: Icon(Icons.picture_as_pdf),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pickPdf();
              },
              child: Text("选择文件"),
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
            prefixIcon: Icon(Icons.folder),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pickImageFolder();
              },
              child: Text("选择文件夹"),
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
            prefixIcon: Icon(Icons.folder),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: TextButton(
              onPressed: () {
                controller.pickBatchImageFolder();
              },
              child: Text("选择文件夹"),
            ),
          ),
          readOnly: true,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
