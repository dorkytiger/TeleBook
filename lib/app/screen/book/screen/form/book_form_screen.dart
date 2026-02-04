import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_controller.dart';

class BookFormScreen extends GetView<BookFormController> {
  const BookFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "添加数据",
        backIconColor: TDTheme.of(context).brandNormalColor,
        onBack: () {
          Get.back();
        },
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              _buildSourceSelection(context),
              _buildForm(context),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TDText("选择导入源"),
        TDText(
          "请选择您想要导入书籍的来源方式",
          textColor: TDTheme.of(context).fontGyColor3,
          font: TDTheme.of(context).fontBodySmall,
        ),
      ],
    );
  }

  Widget _buildSourceSelection(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _addDialogItem(
              context: context,
              icon: Icons.web,
              title: "来自网页",
              isSelected: controller.source.value == BookFormSources.web,
              description: "从网页解析后,下载书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.web;
              },
            ),
            _addDialogItem(
              context: context,
              icon: Icons.archive,
              title: "来自压缩包",
              isSelected: controller.source.value == BookFormSources.archive,
              description: "从压缩包中提取书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.archive;
              },
            ),
            _addDialogItem(
              context: context,
              icon: Icons.archive_sharp,
              title: "来自批量压缩包",
              isSelected:
                  controller.source.value == BookFormSources.batchArchive,
              description: "选择文件夹,从文件夹里面多个压缩包中提取书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.batchArchive;
              },
            ),
            _addDialogItem(
              context: context,
              icon: Icons.picture_as_pdf,
              title: "来自PDF文件",
              isSelected: controller.source.value == BookFormSources.pdf,
              description: "从PDF文件中提取书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.pdf;
              },
            ),
            _addDialogItem(
              context: context,
              icon: Icons.image,
              title: "来自图片文件夹",
              isSelected:
                  controller.source.value == BookFormSources.imageFolder,
              description: "从图片文件夹中提取书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.imageFolder;
              },
            ),
            _addDialogItem(
              context: context,
              icon: Icons.folder,
              title: "来自批量图片文件夹",
              isSelected:
                  controller.source.value == BookFormSources.batchImageFolder,
              description: "选择文件夹,从文件夹里面多个图片文件夹中提取书籍到本地",
              onTap: () {
                controller.source.value = BookFormSources.batchImageFolder;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    switch (controller.source.value) {
      case BookFormSources.web:
        return TDInput(
          controller: controller.webUrlController,
          hintText: "请输入书籍网址",
          autofocus: false,
        );
      case BookFormSources.archive:
        return TDInput(
          controller: controller.filePathController,
          hintText: "请选择压缩包文件",
          readOnly: true,
          needClear: false,
          rightBtn: TDButton(
            text: "选择文件",
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pickArchiveFile();
            },
          ),
        );
      case BookFormSources.batchArchive:
        return TDInput(
          controller: controller.folderPathController,
          hintText: "请选择包含压缩包的文件夹",
          readOnly: true,
          needClear: false,
          rightBtn: TDButton(
            text: "选择文件夹",
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pickFolder();
            },
          ),
        );
      case BookFormSources.pdf:
        return TDInput(
          controller: controller.pdfPathController,
          hintText: "请选择PDF文件",
          readOnly: true,
          needClear: false,
          rightBtn: TDButton(
            text: "选择文件",
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pickPdf();
            },
          ),
        );
      case BookFormSources.imageFolder:
        return TDInput(
          controller: controller.imageFolderPathController,
          hintText: "请选择图片文件夹",
          readOnly: true,
          needClear: false,
          rightBtn: TDButton(
            text: "选择文件夹",
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pickImageFolder();
            },
          ),
        );
      case BookFormSources.batchImageFolder:
        return TDInput(
          controller: controller.batchImageFolderPathController,
          hintText: "请选择包含图片文件夹的文件夹",
          readOnly: true,
          needClear: false,
          rightBtn: TDButton(
            text: "选择文件夹",
            theme: TDButtonTheme.primary,
            onTap: () {
              controller.pickBatchImageFolder();
            },
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildActionButton(BuildContext context) {
    return TDButton(
      text: "添加书籍",
      width: double.infinity,
      theme: TDButtonTheme.primary,
      onTap: () {
        controller.submitForm();
      },
    );
  }

  Widget _addDialogItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: TDTheme.of(context).fontGyColor4.withValues(alpha: 0.05),
        splashColor: TDTheme.of(
          context,
        ).brandNormalColor.withValues(alpha: 0.1),
        highlightColor: TDTheme.of(
          context,
        ).brandNormalColor.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? TDTheme.of(context).fontGyColor4.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? TDTheme.of(context).fontGyColor4
                  : Colors.transparent,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: TDTheme.of(
                    context,
                  ).fontGyColor4.withValues(alpha: 0.1),
                ),
                padding: EdgeInsets.all(16),
                child: Icon(icon),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TDText(title),
                    TDText(
                      description,
                      overflow: TextOverflow.clip,
                      textColor: TDTheme.of(context).fontGyColor3,
                      font: TDTheme.of(context).fontBodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
