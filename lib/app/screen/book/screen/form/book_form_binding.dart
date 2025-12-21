import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_controller.dart';

class BookFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BookFormController>(
      () => BookFormController(),
    );
  }
}