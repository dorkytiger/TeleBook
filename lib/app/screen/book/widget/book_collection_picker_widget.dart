import 'package:dk_util/state/dk_state_event.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/screen/collection/widget/collection_edit_form_widget.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class BookCollectionPickerWidget extends StatelessWidget {
  final controller = Get.put(BookCollectionPickerController());

  BookCollectionPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '选择收藏夹',
        onBack: () {
          Get.back();
        },
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.add,
            action: () {
              Navigator.of(context).push(
                TDSlidePopupRoute(
                  builder: (context) {
                    return _buildAddCollectionForm(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _buildCollectionList(),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TDTheme.of(context).bgColorContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: TDButton(
          text: "加入到收藏夹",
          theme: TDButtonTheme.primary,
          width: double.infinity,
          onTap: () {
            controller.addBooksToCollection();
          },
        ),
      ),
    );
  }

  Widget _buildCollectionList() {
    return controller.getCollectionsState.displaySuccess(
      successBuilder: (data) {
        return Obx(
          () => TDRadioGroup(
            selectId: controller.selectedCollectionId.value.toString(),
            direction: Axis.vertical,
            cardMode: true,
            directionalTdRadios: [
              ...data.map((collection) {
                final iconData = CollectionConstant.iconList.firstWhere(
                  (icon) => icon.codePoint == collection.icon,
                  orElse: () => Icons.book,
                );
                final color = CollectionConstant.colorList.firstWhere(
                  (color) => color.toARGB32() == collection.color,
                  orElse: () => Colors.blue,
                );

                return TDRadio(
                  id: collection.id.toString(),
                  cardMode: true,
                  customSpace: EdgeInsets.only(top: 8),
                  customContentBuilder: (context, selected, text) {
                    return TDCell(
                      disabled: true,
                      imageWidget: Container(
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 32,
                        width: 32,
                        child: Icon(iconData, color: color, size: 24),
                      ),
                      title: collection.name,
                    );
                  },
                );
              }),
            ],
            onRadioGroupChange: (id) {
              controller.selectedCollectionId.value = int.tryParse(id!);
            },
          ),
        );
      },
    );
  }

  Widget _buildAddCollectionForm(BuildContext context) {
    return CollectionEditFormWidget(
      nameController: controller.collectionNameController,
      onConfirm: () {
        controller.addCollection();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
      onIconSelected: (iconData) {
        controller.selectedCollectionIcon.value = iconData;
      },
      onColorSelected: (color) {
        controller.selectedCollectionColor.value = color;
      },
    );
  }
}

class BookCollectionPickerController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final bookIds = Get.arguments["bookIds"] as List<int>;
  final getCollectionsState = Rx<DKStateQuery<List<CollectionTableData>>>(
    DkStateQueryIdle(),
  );
  final addCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final addBookCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final collectionNameController = TextEditingController();
  final selectedCollectionIcon = Rxn<IconData>(null);
  final selectedCollectionColor = Rxn<Color>(null);
  final selectedCollectionId = Rxn<int>(null);

  @override
  void onInit() {
    super.onInit();
    addCollectionState.listenEventToast(
      onSuccess: (_) {
        getCollections();
        Get.back();
      },
    );
    addBookCollectionState.listenEventToast(
      onSuccess: (_) {
        final controller = Get.find<BookController>();
        controller.fetchBooks();
        Get.back();
      },
    );

    getCollections();
  }

  Future<void> getCollections() async {
    await getCollectionsState.triggerQuery(
      query: () async {
        final query = appDatabase.collectionTable.select()
          ..orderBy([
            (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]);
        final collections = await query.get();
        if (bookIds.length == 1) {
          final bookId = bookIds.first;
          final collectionBookQuery = appDatabase.collectionBookTable.select()
            ..where((tbl) => tbl.bookId.equals(bookId));
          final collectionBooks = await collectionBookQuery.get();
          if (collectionBooks.isNotEmpty) {
            selectedCollectionId.value = collectionBooks.first.collectionId;
          }
        }
        return collections;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> addCollection() async {
    await addCollectionState.triggerEvent(
      event: () async {
        if (selectedCollectionIcon.value == null) {
          throw Exception('请选择图标');
        }
        if (collectionNameController.text.isEmpty) {
          throw Exception('请输入名称');
        }
        if (collectionNameController.text.length > 20) {
          throw Exception('名称不能超过20个字符');
        }
        if (selectedCollectionColor.value == null) {
          throw Exception('请选择颜色');
        }

        final appDatabase = Get.find<AppDatabase>();
        await appDatabase
            .into(appDatabase.collectionTable)
            .insert(
              CollectionTableCompanion.insert(
                name: collectionNameController.text,
                icon: selectedCollectionIcon.value!.codePoint,
                color: selectedCollectionColor.value!.toARGB32(),
              ),
            );
      },
    );
  }

  Future<void> addBooksToCollection() async {
    await addBookCollectionState.triggerEvent(
      event: () async {
        if (selectedCollectionId.value == null) {
          throw Exception('请选择收藏夹');
        }
        // 先删除已有的收藏关系
        await (appDatabase.delete(
          appDatabase.collectionBookTable,
        )..where((tbl) => tbl.bookId.isIn(bookIds))).go();

        // 添加新的收藏关系
        for (final id in bookIds) {
          await appDatabase
              .into(appDatabase.collectionBookTable)
              .insert(
                CollectionBookTableCompanion.insert(
                  bookId: id,
                  collectionId: selectedCollectionId.value!,
                ),
              );
        }
      },
    );
  }

  void clearForm() {
    collectionNameController.clear();
    selectedCollectionColor.value = null;
    selectedCollectionIcon.value = null;
  }
}
