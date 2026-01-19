import 'package:get/get.dart';
import 'package:tele_book/app/screen/collection/screen/book/collection_book_controller.dart';

class CollectionBookBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollectionBookController());
  }
}
