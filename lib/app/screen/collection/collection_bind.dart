import 'package:get/get.dart';
import 'collection_controller.dart';

class CollectionBind extends Bindings {
  @override
  void dependencies() {
      Get.lazyPut<CollectionController>(() => CollectionController());
  }
}