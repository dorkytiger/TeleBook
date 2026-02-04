import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

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
                  focusMove: true,
                  slideTransitionFrom: SlideTransitionFrom.bottom,
                  builder: (context) {
                    return _buildAddMarkForm(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: controller.getMarkState.displaySuccess(
        successBuilder: (data) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildMarkList(context, data)),
                _buildAddBookMarkButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarkList(BuildContext context, List<MarkTableData> data) {
    return TDCheckboxGroup(
      checkedIds: [...controller.selectedMarkIds.map((e) => e.toString())],
      onChangeGroup: (ids) {
        controller.selectedMarkIds.value = ids
            .map((e) => int.parse(e))
            .toList();
      },
      child: Column(
        children: [
          ...data.map(
            (mark) => TDCheckbox(
              id: mark.id.toString(),
              customContentBuilder: (context, selected, title) {
                return TDCell(
                  imageWidget: Container(
                    decoration: BoxDecoration(
                      color: Color(mark.color),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 24,
                    height: 24,
                  ),
                  title: mark.name,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddBookMarkButton(BuildContext context) {
    return TDButton(
      width: double.infinity,
      theme: TDButtonTheme.primary,
      text: "保存选择",
      onTap: () {
        controller.saveBookMarks();
      },
    );
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
  final bookIds = Get.arguments["bookIds"] as List<int>;
  final appDatabase = Get.find<AppDatabase>();
  final getMarkState = Rx<DKStateQuery<List<MarkTableData>>>(
    DkStateQueryIdle(),
  );
  final getBookMarkState = Rx<DKStateQuery<List<MarkBookTableData>>>(
    DkStateQueryIdle(),
  );
  final addMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final addBookMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final markNameController = TextEditingController();
  final selectedMarkColor = Rx<Color>(_colorList.first);
  final selectedMarkIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    addMarkState.listenEventToast(
      onSuccess: (_) {
        fetchMarks();
        markNameController.clear();
        Get.back();
      },
    );
    addBookMarkState.listenEventToast(
      onSuccess: (_) {
        final controller = Get.find<BookController>();
        controller.fetchBooks();
        Get.back();
      },
    );
    fetchMarks();
    fetchBookMarks();
  }

  Future<void> fetchMarks() async {
    await getMarkState.triggerQuery(
      query: () async {
        final query = appDatabase.markTable.select();
        final marks = await query.get();
        return marks;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> fetchBookMarks() async {
    await getBookMarkState.triggerQuery(
      query: () async {
        final query = appDatabase.markBookTable.select()
          ..where((tbl) => tbl.bookId.isIn(bookIds));
        final bookMarks = await query.get();
        if (bookIds.length == 1) {
          selectedMarkIds.value = bookMarks.map((e) => e.markId).toList();
        }
        return bookMarks;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> addBookMark() async {
    final markName = markNameController.text.trim();

    if (markName.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(message: "标签名称不能为空", duration: Duration(seconds: 2)),
      );
      return;
    }

    addMarkState.triggerEvent(
      event: () async {
        // 检查是否已存在同名标签
        final existingMark =
            await (appDatabase.markTable.select()
                  ..where((tbl) => tbl.name.equals(markName)))
                .getSingleOrNull();

        if (existingMark != null) {
          throw Exception("标签名称已存在，请使用其他名称");
        }

        await appDatabase
            .into(appDatabase.markTable)
            .insert(
              MarkTableCompanion.insert(
                name: markName,
                color: selectedMarkColor.value.toARGB32(),
              ),
            );
      },
    );
  }

  Future<void> saveBookMarks() async {
    addBookMarkState.triggerEvent(
      event: () async {
        // 先删除已有的书籍标签关联
        await (appDatabase.markBookTable.delete()
              ..where((tbl) => tbl.bookId.isIn(bookIds)))
            .go();

        // 添加新的书籍标签关联
        for (final bookId in bookIds) {
          for (final markId in selectedMarkIds) {
            await appDatabase
                .into(appDatabase.markBookTable)
                .insert(
                  MarkBookTableCompanion.insert(bookId: bookId, markId: markId),
                );
          }
        }
      },
    );
  }
}
