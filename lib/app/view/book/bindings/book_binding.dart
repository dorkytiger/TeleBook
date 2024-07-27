import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/book_controller.dart';

class BookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookController>(
      () => BookController(),
    );
    Get.lazyPut(() => HomeController());
  }
}
