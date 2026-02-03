import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';

class CollectionController extends GetxController {
  final collectionNameController = TextEditingController();
  final getCollectionState = Rx<DKStateQuery<List<CollectionTableData>>>(
    DkStateQueryIdle(),
  );
  final addCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final editCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final deleteCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    addCollectionState.listenEventToast(
      onSuccess: (_) {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    editCollectionState.listenEventToast(
      onSuccess: (_) {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    deleteCollectionState.listenEventToast(
      onSuccess: (_) {
        getCollections();
        Get.back();
      },
    );

    getCollections();
  }

  Future<void> getCollections() async {
    await getCollectionState.triggerQuery(
      query: () async {
        final query = appDatabase.collectionTable.select()
          ..orderBy([
            (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]);
        final collections = await query.get();
        return collections;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> addCollection() async {
    // await addCollectionState.triggerEvent(
    //   event: () async {
    //     appDatabase
    //         .into(appDatabase.collectionTable)
    //         .insert(
    //           CollectionTableCompanion.insert(
    //             id: Value.absent(),
    //             name: collectionNameController.text,
    //             order: Value(0),
    //             createdAt: Value(DateTime.now()),
    //           ),
    //         );
    //   },
    // );
  }

  Future<void> editCollection(int id) async {
    // await editCollectionState.triggerEvent(
    //   event: () async {
    //     await appDatabase
    //         .update(appDatabase.collectionTable)
    //         .replace(
    //           CollectionTableData(
    //             id: id,
    //             name: collectionNameController.text,
    //             order: 0,
    //             createdAt: DateTime.now(),
    //           ),
    //         );
    //   },
    // );
  }

  Future<void> deleteCollection(int id) async {
    // await deleteCollectionState.triggerEvent(
    //   event: () async {
    //     await appDatabase
    //         .delete(appDatabase.collectionTable)
    //         .delete(
    //           CollectionTableData(
    //             id: id,
    //             name: '',
    //             order: 0,
    //             createdAt: DateTime.now(),
    //           ),
    //         );
    //   },
    // );
  }
}
