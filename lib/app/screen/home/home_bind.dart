import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/collection/collection_bind.dart';
import 'package:tele_book/app/screen/import/import_bind.dart';
import 'package:tele_book/app/screen/mark/mark_bind.dart';
import 'package:tele_book/app/screen/task/task_bind.dart';
import 'home_controller.dart';

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    // 组合子页面的 Bindings
    BookBinding().dependencies();
    TaskBind().dependencies();
    CollectionBind().dependencies();
    MarkBind().dependencies();
  }
}
