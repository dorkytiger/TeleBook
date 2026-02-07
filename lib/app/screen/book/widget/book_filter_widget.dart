import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/widget/td/td_cell_image_icon_widget.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class BookFilterWidget extends StatelessWidget {
  final controller = Get.find<BookController>();

  BookFilterWidget({super.key}) {
    controller.getCollections();
    controller.getMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TDTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              TDFormItemTitle(label: "搜索"),
              TDSearchBar(
                placeHolder: "搜索书籍名称",
                controller: controller.searchBarController,
              ),
              TDFormItemTitle(label: "显示方式"),
              Obx(
                () => Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: TDButton(
                        text: "网格",
                        icon: Icons.grid_on,
                        theme:
                            controller.bookLayout.value ==
                                BookLayoutSetting.grid
                            ? TDButtonTheme.primary
                            : TDButtonTheme.defaultTheme,
                        onTap: () {
                          controller.triggerBookLayoutChange(
                            BookLayoutSetting.grid,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: TDButton(
                        text: "列表",
                        icon: Icons.list,
                        theme:
                            controller.bookLayout.value ==
                                BookLayoutSetting.list
                            ? TDButtonTheme.primary
                            : TDButtonTheme.defaultTheme,
                        onTap: () {
                          controller.triggerBookLayoutChange(
                            BookLayoutSetting.list,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              TDFormItemTitle(label: "收藏夹"),
              _buildCollectionFilter(context),
              TDFormItemTitle(label: "标签"),
              _buildMarkFilter(context),
              Obx(() {
                if (controller.selectedCollectionId.value != null ||
                    controller.selectedMarkIds.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TDButton(
                      text: "清除所有筛选",
                      width: double.infinity,
                      theme: TDButtonTheme.primary,
                      size: TDButtonSize.large,
                      type: TDButtonType.outline,
                      onTap: () {
                        controller.clearAllFilters();
                      },
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionFilter(BuildContext context) {
    return controller.getCollectionState.displaySuccess(
      successBuilder: (collections) {
        return Obx(
          () => Column(
            spacing: 16,
            children: [
              TDCell(
                style: _getCollectionCellStyle(
                  context,
                  controller.selectedCollectionId.value == null,
                ),

                title: "全部收藏夹",
                imageWidget: TDCellImageIconWidget(
                  iconData: Icons.all_inbox,
                  color: controller.selectedCollectionId.value == null
                      ? Colors.white
                      : TDTheme.of(context).brandColor7,
                ),
                onClick: (cell) {
                  controller.toggleCollectionFilter(null);
                },
              ),
              ...collections.map((collection) {
                final iconData = CollectionConstant.iconList.firstWhere(
                  (icon) => icon.codePoint == collection.icon,
                  orElse: () => CollectionConstant.iconList.first,
                );

                final colorData = CollectionConstant.colorList.firstWhere(
                  (color) => color.toARGB32() == collection.color,
                  orElse: () => CollectionConstant.colorList.first,
                );
                final isSelected =
                    controller.selectedCollectionId.value == collection.id;

                return TDCell(
                  style: _getCollectionCellStyle(context, isSelected),
                  title: collection.name,
                  imageWidget: TDCellImageIconWidget(
                    iconData: iconData,
                    color: isSelected ? Colors.white : colorData,
                  ),
                  onClick: (cell) {
                    controller.toggleCollectionFilter(collection.id);
                  },
                );
              }),
            ],
          ),
        );
      },
      loadingBuilder: () => Center(child: TDCircleIndicator()),
      emptyBuilder: () =>
          TDText("暂无收藏夹",),
      errorBuilder: (error) =>
          TDText("加载失败", textColor: TDTheme.of(context).errorColor6),
    );
  }

  Widget _buildMarkFilter(BuildContext context) {
    return controller.getMarkState.displaySuccess(
      successBuilder: (marks) {
        return Obx(() {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: marks.map((mark) {
              final isSelected = controller.selectedMarkIds.contains(mark.id);
              return GestureDetector(
                onTap: () {
                  controller.toggleMarkFilter(mark.id);
                },
                child: TDTag(
                  mark.name,
                  size: TDTagSize.large,
                  theme: isSelected
                      ? TDTagTheme.primary
                      : TDTagTheme.defaultTheme,
                  backgroundColor: isSelected
                      ? null
                      : Color(mark.color).withValues(alpha: 0.1),
                  textColor: isSelected
                      ? null
                      : Color(mark.color),
                ),
              );
            }).toList(),
          );
        });
      },
      loadingBuilder: () => Center(child: TDCircleIndicator()),
      emptyBuilder: () =>
          TDText("暂无标签"),
      errorBuilder: (error) =>
          TDText("加载失败", textColor: TDTheme.of(context).errorColor6),
    );
  }

  TDCellStyle _getCollectionCellStyle(BuildContext context, bool isSelected) {
    final cellStyle = TDCellStyle.cellStyle(context);
    cellStyle.backgroundColor = isSelected
        ? TDTheme.of(context).brandNormalColor
        : TDTheme.of(context).bgColorContainer;
    cellStyle.clickBackgroundColor = isSelected
        ? TDTheme.of(context).brandNormalColor.withValues(alpha: 0.8)
        : TDTheme.of(context).bgColorContainerHover;
    cellStyle.titleStyle = TextStyle(
      color: isSelected ? Colors.white : TDTheme.of(context).textColorPrimary,
      fontSize: TDTheme.of(context).fontBodyLarge?.size ?? 16,
      fontWeight: FontWeight.w500,
    );
    cellStyle.borderedColor = isSelected
        ? TDTheme.of(context).brandNormalColor
        : TDTheme.of(context).componentStrokeColor;
    return cellStyle;
  }
}
