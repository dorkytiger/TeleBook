import 'package:get/get.dart';
import 'parse_batch_image_folder_controller.dart';
class ParseBatchImageFolderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParseBatchImageFolderController>(() => ParseBatchImageFolderController());
  }
}
