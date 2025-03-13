import 'package:get/get.dart';
import 'package:tele_book/app/view/book/view/book_page_controller.dart';

class BookPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookPageController>(() => BookPageController());
  }
}