import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/cupertino.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

final _iconList = [
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

final _colorList = [
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

class BookMarkPickerWidget extends StatelessWidget {
  final controller = Get.put(BookMarkPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "选择书签",
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
                    return _buildAddMarkForm(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: controller.getBookMarkState.displaySuccess(
        successBuilder: (data) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildTitle(context), _buildTagWrap(context, data)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TDText("选择标签", font: TDTheme.of(context).fontTitleLarge),
        TDText(
          "为书籍添加多个标签",
          font: TDTheme.of(context).fontTitleMedium,
          textColor: TDTheme.of(context).grayColor6,
        ),
      ],
    );
  }

  Widget _buildTagWrap(BuildContext context, List<MarkTableData> data) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        children: [
          ...data.map((mark) {
            final isSelected = controller.selectedMarks.any(
              (selected) => selected.id == mark.id,
            );
            return GestureDetector(
              child: TDTag(
                mark.name,
                size: TDTagSize.large,
                icon: IconData(mark.icon),
                textColor: isSelected ? Colors.white : Color(mark.color),
                backgroundColor: isSelected
                    ? TDTheme.of(context).brandNormalColor
                    : Color(mark.color).withOpacity(0.1),
                shape: TDTagShape.round,
                needCloseIcon: true,
              ),
            );
          }),
        ],
      );
    });
  }

  Widget _buildAddMarkForm(BuildContext context) {
    return TDPopupBottomConfirmPanel(
      rightClick: () {
        controller.addBookMark();
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
            TDFormItemTitle(label: "标签名称", required: true),
            TDInput(
              controller: controller.markNameController,
              hintText: "请输入标签名称",
            ),
            TDFormItemTitle(label: "选择图标", required: true),
            TDRadioGroup(
              cardMode: true,
              direction: Axis.horizontal,
              rowCount: 5,
              onRadioGroupChange: (id) {
                final iconData = _iconList.firstWhere(
                  (icon) => icon.codePoint.toString() == id,
                );
                controller.selectedMarkIcon.value = iconData;
              },
              directionalTdRadios: [
                ..._iconList.map(
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
                final color = _colorList.firstWhere(
                  (color) => color.toARGB32().toString() == id,
                );
                controller.selectedMarkColor.value = color;
              },
              directionalTdRadios: [
                ..._colorList.map(
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

class BookMarkPickerController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final getBookMarkState = Rx<DKStateQuery<List<MarkTableData>>>(
    DkStateQueryIdle(),
  );
  final addBookMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final markNameController = TextEditingController();
  final selectedMarkColor = Rx<Color>(_colorList.first);
  final selectedMarkIcon = Rx<IconData>(_iconList.first);
  final selectedMarks = <MarkTableData>[].obs;

  @override
  void onInit() {
    super.onInit();
    addBookMarkState.listenEventToast(
      onSuccess: (_) {
        fetchBookMarks();
        markNameController.clear();
        Get.back();
      },
    );
    fetchBookMarks();
  }

  Future<void> fetchBookMarks() async {
    await getBookMarkState.triggerQuery(
      query: () async {
        final query = appDatabase.markTable.select();
        final marks = await query.get();
        return marks;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> addBookMark() async {
    addBookMarkState.triggerEvent(
      event: () async {
        await appDatabase
            .into(appDatabase.markTable)
            .insert(
              MarkTableCompanion.insert(
                name: markNameController.text,
                icon: selectedMarkIcon.value.codePoint,
                color: selectedMarkColor.value.toARGB32(),
              ),
            );
      },
    );
  }
}
