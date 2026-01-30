import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';

class MarkController extends GetxController {
  final getMarkListState = Rx<DKStateQuery<List<MarkTableData>>>(
    DkStateQueryIdle(),
  );
  final addMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final db = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    addMarkState.listenEvent();
    getMarkList();
  }

  Future<void> getMarkList() async {
    getMarkListState.query(
      query: () async {
        return db.markTable.select().get();
      },
      isEmpty: (data) => data.isEmpty,
    );
  }
}
