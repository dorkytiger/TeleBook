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
            onBack: () {
              Get.back();
            },
            rightBarItems: [
              TDNavBarItem(
                  icon: Icons.check,
                  action: () {
                    controller.formController.submit();
                  })
            ]),
        body: Obx(
          () => TDForm(
              formController: controller.formController,
              formContentAlign: TextAlign.left,
              items: [
                TDFormItem(
                    type: TDFormItemType.cascader,
                    name: 'source',
                    label: "数据源",
                    labelWidth: 90,
                    formItemNotifier: controller.formItemNotify['source'],
                    select: controller.source.value?.desc ?? "请选择数据源",
                    selectFn: (BuildContext context) {
                      TDPicker.showMultiPicker(context, onConfirm: (data) {
                        final index = data.first as int;
                        controller.source.value = BookFormSources.values[index];
                        controller.formItemNotify['source']
                            .upDataForm(controller.source.value!.value);
                        Navigator.of(context).pop();
                      }, data: [
                        BookFormSources.values.map((e) => e.desc).toList()
                      ]);
                    }),
                if (controller.source.value != null &&
                    controller.source.value == BookFormSources.web)
                  TDFormItem(
                    type: TDFormItemType.input,
                    name: 'url',
                    formItemNotifier: controller.formItemNotify['url'],
                    label: "网址",
                    labelWidth: 82.0,

                    child: TDTextarea(
                      hintText: "请输入数据网址",
                      bordered: false,
                      onChanged: (value) {
                        controller.formItemNotify['url'].upDataForm(value);
                      },
                    ),
                  ),
                if (controller.source.value != null &&
                    controller.source.value == BookFormSources.archive)
                  TDFormItem(
                    type: TDFormItemType.input,
                    name: 'file',
                    formItemNotifier: controller.formItemNotify['file'],
                    label: "文件路径",
                    labelWidth: 82.0,
                    child: TDInput(
                        hintText: "请输入文件路径",
                        controller: controller.filePathController,
                        readOnly: true,
                        rightBtn: TDButton(
                          text: "选择文件",
                          theme: TDButtonTheme.primary,
                          type: TDButtonType.text,
                          onTap: () async {
                            await controller.pickArchiveFile();
                          },
                        )),
                  ),
                if (controller.source.value != null &&
                    controller.source.value == BookFormSources.batchArchive)
                  TDFormItem(
                    type: TDFormItemType.input,
                    name: 'folder',
                    formItemNotifier: controller.formItemNotify['folder'],
                    label: "文件夹",
                    labelWidth: 82.0,
                    child: TDInput(
                        hintText: "请选择文件夹",
                        controller: controller.folderPathController,
                        readOnly: true,
                        rightBtn: TDButton(
                          text: "选择文件夹",
                          theme: TDButtonTheme.primary,
                          type: TDButtonType.text,
                          onTap: () async {
                            await controller.pickFolder();
                          },
                        )),
                  )
              ],
              rules: controller.validationRules,
              onSubmit: (Map<String, dynamic> formData, bool isValid) {
                controller.submitForm(formData, isValid);
              },
              data: controller.formData),
        ));
  }
}
