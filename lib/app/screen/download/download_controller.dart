import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/util/request_state.dart';

class DownloadController extends GetxController {
  final downloadService = Get.find<DownloadService>();
  final appDatabase = Get.find<AppDatabase>();
  final saveToBookState = Rx<RequestState>(Idle());

  @override
  void onInit() {
    super.onInit();
    saveToBookState.listenWithSuccess(
      onSuccess: () {
        final bookController = Get.find<BookController>();
        bookController.fetchBooks();
      },
    );
  }

  Future<void> savaToBook(String groupId) async {
    saveToBookState.value.handleFunction(
      function: () async {
        final group = downloadService.groups[groupId];
        if (group == null) {
          throw Exception("未找到下载组 $groupId");
        }
        if (group.completedCount != group.totalCount) {
          throw Exception("下载未完成，无法保存到书架");
        }
        final tasks = downloadService.getTasksByGroup(groupId);
        final savePaths = tasks.map((e) => e.savePath.value).toList();
        await appDatabase.bookTable.insertOnConflictUpdate(
          BookTableCompanion(
            name: Value(group.name),
            localPaths: Value(savePaths),
          ),
        );
      },
      onStateChanged: (newState) {
        saveToBookState.value = newState;
      },
    );
  }
}
