import 'package:get/get.dart';
import 'package:tele_book/app/service/export_service.dart';

import 'book_controller.dart';

class BookBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<BookController>(
      () => BookController(),
    );
  }
}
