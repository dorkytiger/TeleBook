import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookFormController extends GetxController {
  final source = Rxn<BookFormSources>(null);
  final formController = FormController();
  final submitFormState = Rx<RequestState<void>>(Idle());
  final filePathController = TextEditingController();
  final folderPathController = TextEditingController();
  final Map<String, dynamic> formData = {
    'source': null,
    'url': null,
    'file': null,
    'folder': null,
  };
  final Map<String, dynamic> formItemNotify = {
    'source': '',
    'url': '',
    'file': '',
    'folder': '',
  };
  late final Map<String, TDFormValidation> validationRules = {
    'source': TDFormValidation(
        validate: (value) {
          if (value == null || value.isEmpty) {
            return 'empty';
          }
          return null;
        },
        errorMessage: '请选择来源',
        type: TDFormItemType.cascader),
    'url': TDFormValidation(
        validate: (value) {
          if (formData['source'] == BookFormSources.web.value) {
            if (value == null || value.isEmpty) {
              return 'empty';
            }
          }
          return null;
        },
        errorMessage: '请输入网址',
        type: TDFormItemType.input),
    'file': TDFormValidation(
        validate: (value) {
          if (formData['source'] == BookFormSources.archive.value) {
            if (value == null || value.isEmpty) {
              return 'empty';
            }
          }
          return null;
        },
        errorMessage: '请输入文件路径',
        type: TDFormItemType.input),
    'folder': TDFormValidation(
        validate: (value) {
          if (formData['source'] == BookFormSources.batchArchive.value) {
            if (value == null || value.isEmpty) {
              return 'empty';
            }
          }
          return null;
        },
        errorMessage: '请选择文件夹',
        type: TDFormItemType.input),
  };

  Future<void> submitForm(Map<String, dynamic> formData, bool isValid) async {
    if (!isValid) {
      return;
    }

    final sourceValue = formData['source'];
    if (sourceValue == BookFormSources.web.value) {
      final url = formData['url'] as String;
      // 然后打开解析页面
      Get.toNamed("/parse/web", arguments: url);
    }
    if (sourceValue == BookFormSources.archive.value) {
      final file = formData['file'] as String;
      Get.toNamed('/parse/archive/single', arguments: file);
    }
    if (sourceValue == BookFormSources.batchArchive.value) {
      final folder = formData['folder'] as String;
      Get.toNamed('/parse/archive/batch', arguments: folder);
    }
  }

  Future<void> pickArchiveFile() async {
    final result = await PickFileUtil.pickerFile(
      type: FileType.custom,
      allowedExtensions: ['zip', 'rar', '7z', 'cbz', 'cbr'],
    );
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        formData['file'] = filePath;
        formItemNotify['file'].upDataForm(filePath);
        filePathController.text = filePath;
      }
    }
  }

  Future<void> pickFolder() async {
    final folderPath = await PickFileUtil.pickDirectory();
    if (folderPath != null) {
      formData['folder'] = folderPath;
      formItemNotify['folder'].upDataForm(folderPath);
      folderPathController.text = folderPath;
    }
  }

  @override
  void onInit() {
    super.onInit();
    formData.forEach((key, value) {
      formItemNotify[key] = FormItemNotifier();
    });
  }
}

enum BookFormSources {
  web("web", "网页"),
  archive("archive", "压缩包"),
  batchArchive("batch_archive", "批量压缩包");

  final String value;
  final String desc;

  const BookFormSources(this.value, this.desc);
}
