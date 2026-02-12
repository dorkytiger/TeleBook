import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/enum/setting/book_sort_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/widget/td/td_cell_image_icon_widget.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class BookFilterWidget extends StatelessWidget {
  final controller = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text('搜索', style: Theme.of(context).textTheme.titleMedium),
          TextField(
            controller: controller.searchBarController,
            decoration: InputDecoration(
              hintText: "输入书籍标题或作者进行搜索",
              prefixIcon: Icon(Icons.search),
              suffixIcon: controller.searchBarController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.searchBarController.clear();
                      },
                      child: Icon(Icons.close, size: 18),
                    )
                  : SizedBox.shrink(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: TDTheme.of(context).grayColor1,
            ),
          ),
          Text('布局', style: Theme.of(context).textTheme.titleMedium),
          Obx(
            () => Row(
              spacing: 16,
              children: [
                Expanded(
                  child: SegmentedButton<BookLayoutSetting>(
                    segments: [
                      ButtonSegment(
                        value: BookLayoutSetting.grid,
                        label: Text("网格"),
                        icon: Icon(Icons.grid_view),
                      ),
                      ButtonSegment(
                        value: BookLayoutSetting.list,
                        label: Text("列表"),
                        icon: Icon(Icons.list),
                      ),
                    ],
                    onSelectionChanged: (value) {
                      controller.triggerBookLayoutChange(value.first);
                    },
                    selected: {controller.bookLayout.value},
                  ),
                ),
              ],
            ),
          ),
          Text("按标题排序", style: Theme.of(context).textTheme.titleMedium),
          Obx(
            () => Row(
              spacing: 16,
              children: [
                Expanded(
                  child: SegmentedButton<BookTitleSortSetting>(
                    selected: {controller.bookTitleSort.value},
                    segments: [
                      ButtonSegment(
                        value: BookTitleSortSetting.titleAsc,
                        label: Text("标题升序"),
                        icon: Icon(Icons.title),
                      ),
                      ButtonSegment(
                        value: BookTitleSortSetting.titleDesc,
                        label: Text("标题降序"),
                        icon: Icon(Icons.title),
                      ),
                    ],
                    onSelectionChanged: (value) {
                      controller.triggerBookTitleSortChange(value.first);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
