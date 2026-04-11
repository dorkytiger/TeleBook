import 'package:get/get.dart';
import 'book_filter_controller.dart';

class BookFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookFilterController>(() => BookFilterController());
  }
}

