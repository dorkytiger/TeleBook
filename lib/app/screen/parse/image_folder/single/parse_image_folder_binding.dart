import 'package:get/get.dart';
import 'parse_image_folder_controller.dart';

class ParseImageFolderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParseImageFolderController>(
      () => ParseImageFolderController(),
    );
  }
}
