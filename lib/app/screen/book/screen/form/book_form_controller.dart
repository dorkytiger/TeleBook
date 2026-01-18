import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookFormController extends GetxController {
  final source = Rxn<BookFormSources>(null);
  final formController = FormController();
  final submitFormState = Rx<RequestState<void>>(Idle());
  final filePathController = TextEditingController();
  final folderPathController = TextEditingController();
  final pdfPathController = TextEditingController();
  final Map<String, dynamic> formData = {
    'source': null,
    'url': null,
    'file': null,
    'folder': null,
    'pdf': null,
  };
  final Map<String, dynamic> formItemNotify = {
    'source': '',
    'url': '',
    'file': '',
    'folder': '',
    'pdf': '',
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
      type: TDFormItemType.cascader,
    ),
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
      type: TDFormItemType.input,
    ),
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
      type: TDFormItemType.input,
    ),
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
      type: TDFormItemType.input,
    ),
    'pdf': TDFormValidation(
      validate: (value) {
        if (formData['source'] == BookFormSources.pdf.value) {
          if (value == null || value.isEmpty) {
            return 'empty';
          }
        }
        return null;
      },
      errorMessage: '请选择PDF文件',
      type: TDFormItemType.input,
    ),
  };

  Future<void> submitForm(Map<String, dynamic> formData, bool isValid) async {
    if (!isValid) {
      return;
    }

    final sourceValue = formData['source'];
    if (sourceValue == BookFormSources.web.value) {
      final url = formData['url'];
      if (url == null || url.toString().trim().isEmpty) {
        return;
      }
      // 然后打开解析页面
      Get.offAndToNamed("/parse/web", arguments: url.toString());
    }
    if (sourceValue == BookFormSources.archive.value) {
      final file = formData['file'];
      if (file == null || file.toString().trim().isEmpty) {
        return;
      }
      Get.offAndToNamed('/parse/archive/single', arguments: file.toString());
    }
    if (sourceValue == BookFormSources.batchArchive.value) {
      final folder = formData['folder'];
      if (folder == null || folder.toString().trim().isEmpty) {
        return;
      }
      Get.offAndToNamed('/parse/archive/batch', arguments: folder.toString());
    }
    if (sourceValue == BookFormSources.pdf.value) {
      final pdf = formData['pdf'];
      if (pdf == null || pdf.toString().trim().isEmpty) {
        return;
      }
      Get.offAndToNamed('/parse/pdf', arguments: {'path': pdf.toString()});
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

  Future<void> pickPdf() async {
    final path = await PdfPicker.pickPdf();
    if (path != null) {
      formData['pdf'] = path;
      formItemNotify['pdf'].upDataForm(path);
      pdfPathController.text = path;
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
  batchArchive("batch_archive", "批量压缩包"),
  pdf("pdf", "PDF");

  final String value;
  final String desc;

  const BookFormSources(this.value, this.desc);
}
