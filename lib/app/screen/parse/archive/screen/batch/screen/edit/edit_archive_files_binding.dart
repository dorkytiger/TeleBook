import 'package:get/get.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_controller.dart';

class EditArchiveFilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditArchiveFilesController());
  }
}

