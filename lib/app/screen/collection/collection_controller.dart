import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/util/request_state.dart';

class CollectionController extends GetxController {
  final collectionNameController = TextEditingController();
  final getCollectionState = Rx<RequestState<List<CollectionTableData>>>(
    Idle(),
  );
  final addCollectionState = Rx<RequestState<void>>(Idle());
  final editCollectionState = Rx<RequestState<void>>(Idle());
  final deleteCollectionState = Rx<RequestState<void>>(Idle());
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    addCollectionState.listenWithSuccess(
      onSuccess: () {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    editCollectionState.listenWithSuccess(
      onSuccess: () {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    deleteCollectionState.listenWithSuccess(
      onSuccess: () {
        getCollections();
        Get.back();
      },
    );

    getCollections();
  }

  Future<void> getCollections() async {
    await getCollectionState.runFuture(() async {
      final query = appDatabase.collectionTable.select()
        ..orderBy([
          (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);
      final collections = await query.get();
      return collections;
    }, isEmpty: (result) => result.isEmpty);
  }

  Future<void> addCollection() async {
    await addCollectionState.runFuture(() async {
      appDatabase
          .into(appDatabase.collectionTable)
          .insert(
            CollectionTableCompanion.insert(
              id: Value.absent(),
              name: collectionNameController.text,
              order: Value(0),
              createdAt: Value(DateTime.now()),
            ),
          );
    });
  }

  Future<void> editCollection(int id) async {
    await editCollectionState.runFuture(() async {
      await appDatabase
          .update(appDatabase.collectionTable)
          .replace(
            CollectionTableData(
              id: id,
              name: collectionNameController.text,
              order: 0,
              createdAt: DateTime.now(),
            ),
          );
    });
  }

  Future<void> deleteCollection(int id) async {
    await deleteCollectionState.runFuture(() async {
      await appDatabase
          .delete(appDatabase.collectionTable)
          .delete(
            CollectionTableData(
              id: id,
              name: '',
              order: 0,
              createdAt: DateTime.now(),
            ),
          );
    });
  }
}
