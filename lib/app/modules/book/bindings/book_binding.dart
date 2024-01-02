import 'package:get/get.dart';

import '../controllers/book_controller.dart';

class BookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(
      () => BookController(),
    );
  }
}
