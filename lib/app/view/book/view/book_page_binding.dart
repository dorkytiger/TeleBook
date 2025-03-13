import 'package:get/get.dart';
import 'package:wo_nas/app/view/book/view/book_page_controller.dart';

class BookPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookPageController>(() => BookPageController());
  }
}