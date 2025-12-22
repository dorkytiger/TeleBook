import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_controller.dart';

class BookEditBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BookEditController>(
      () => BookEditController()
    );
  }
}