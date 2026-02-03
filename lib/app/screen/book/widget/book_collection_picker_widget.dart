import 'package:dk_util/state/dk_state_event.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class BookCollectionPickerWidget extends StatelessWidget {
  final Function(CollectionTableData) onCollectionSelected;

  final controller = Get.put(BookCollectionPickerController());

  BookCollectionPickerWidget({super.key, required this.onCollectionSelected});

  final iconList = [
    Icons.star,
    Icons.favorite,
    Icons.book,
    Icons.music_note,
    Icons.movie,
    Icons.work,
    Icons.home,
    Icons.travel_explore,
    Icons.fitness_center,
    Icons.pets,
  ];

  final colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
  ];

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
          color: TDTheme.of(context).whiteColor1,
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
            onCollectionSelected(
              controller.getCollectionsState.value.data.firstWhere(
                (collection) =>
                    collection.id == controller.selectedCollectionId.value,
              ),
            );
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
            // cardMode: true,
            directionalTdRadios: [
              ...data.map((collection) {
                final iconData = iconList.firstWhere(
                  (icon) => icon.codePoint == collection.icon,
                  orElse: () => Icons.book,
                );
                final color = colorList.firstWhere(
                  (color) => color.toARGB32() == collection.color,
                  orElse: () => Colors.blue,
                );

                return TDRadio(
                  id: collection.id.toString(),
                  // cardMode: true,
                  customContentBuilder: (context, selected, text) {
                    return TDCell(
                      disabled: true,
                      imageWidget: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(iconData, color: color, size: 24),
                      ),
                      title: collection.name,
                      onClick: (cell) {
                        onCollectionSelected(collection);
                      },
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
    return TDPopupBottomConfirmPanel(
      rightClick: () {
        controller.addCollection();
      },
      leftClick: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            TDFormItemTitle(label: "收藏夹名称", required: true),
            TDInput(
              controller: controller.collectionNameController,
              hintText: "请输入收藏夹名称",
            ),
            TDFormItemTitle(label: "选择图标", required: true),
            TDRadioGroup(
              cardMode: true,
              direction: Axis.horizontal,
              rowCount: 5,
              onRadioGroupChange: (id) {
                final iconData = iconList.firstWhere(
                  (icon) => icon.codePoint.toString() == id,
                );
                controller.selectedCollectionIcon.value = iconData;
              },
              directionalTdRadios: [
                ...iconList.map(
                  (iconData) => TDRadio(
                    id: iconData.codePoint.toString(),
                    cardMode: true,
                    backgroundColor: TDTheme.of(context).grayColor1,
                    customContentBuilder: (context, selected, text) {
                      return Icon(
                        iconData,
                        color: selected ? Colors.blue : Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
            TDFormItemTitle(label: "选择颜色", required: true),
            TDRadioGroup(
              cardMode: true,
              direction: Axis.horizontal,
              rowCount: 5,
              onRadioGroupChange: (id) {
                final color = colorList.firstWhere(
                  (color) => color.toARGB32().toString() == id,
                );
                controller.selectedCollectionColor.value = color;
              },
              directionalTdRadios: [
                ...colorList.map(
                  (color) => TDRadio(
                    id: color.toARGB32().toString(),
                    cardMode: true,
                    backgroundColor: color,
                    customContentBuilder: (context, selected, text) {
                      return selected
                          ? Icon(Icons.check, color: Colors.white)
                          : SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookCollectionPickerController extends GetxController {
  final getCollectionsState = Rx<DKStateQuery<List<CollectionTableData>>>(
    DkStateQueryIdle(),
  );
  final addCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
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
    getCollections();
  }

  Future<void> getCollections() async {
    await getCollectionsState.triggerQuery(
      query: () async {
        final appDatabase = Get.find<AppDatabase>();
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

  void clearForm() {
    collectionNameController.clear();
    selectedCollectionColor.value = null;
    selectedCollectionIcon.value = null;
  }
}
