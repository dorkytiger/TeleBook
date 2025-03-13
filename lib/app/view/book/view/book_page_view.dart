import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/book_page_layout_enum.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/view/book_page_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class BookPageView extends GetView<BookPageController> {
  const BookPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = controller.book;
    return Scaffold(
        appBar: TDNavBar(
          title: book.name,
        ),
        body: () {
          return Obx(() => DisplayResult(
                state: controller.getBookState.value,
                onError: (error) {
                  return Center(
                    child: TDResult(
                      theme: TDResultTheme.error,
                      title: "加载失败",
                      description: error,
                    ),
                  );
                },
                onLoading: () {
                  return const Center(
                    child: TDLoading(size: TDLoadingSize.large),
                  );
                },
                onSuccess: (value) => _pageView(book, context, controller),
              ));
        }());
  }

  Widget _pageView(
      BookTableData data, BuildContext context, BookPageController controller) {
    final urls = data.isDownload ? data.localPaths : data.imageUrls;
    return PageView.builder(
        scrollDirection: controller.layout.value == BookPageLayout.column
            ? Axis.vertical
            : Axis.horizontal,
        controller: controller.pageController,
        itemCount: urls.length,
        onPageChanged: (index) {
          controller.onPageChanged(index);
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTapDown: (details) {
              final screenWidth = MediaQuery.of(context).size.width;
              final tapPosition = details.globalPosition.dx;
              if (tapPosition < screenWidth / 3) {
                // Tap on the left third of the screen
                if (controller.pageController.page! > 0) {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else if (tapPosition > 2 * screenWidth / 3) {
                // Tap on the right third of the screen
                if (controller.pageController.page! < urls.length - 1) {
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else {
                Navigator.of(context).push(TDSlidePopupRoute(
                    modalBarrierColor: TDTheme.of(context).fontGyColor2,
                    slideTransitionFrom: SlideTransitionFrom.bottom,
                    builder: (context) {
                      return Material(
                          child: SizedBox(
                        height: 100,
                        child: TDSlider(
                          sliderThemeData: TDSliderThemeData(
                            scaleFormatter: (value) => value.toInt().toString(),
                            showThumbValue: true,
                            context: context,
                            min: 0,
                            max: urls.length.toDouble(),
                          ),
                          leftLabel: '0',
                          rightLabel: '${urls.length}',
                          value: controller.pageController.page!.toDouble(),
                          onChanged: (value) {
                            controller.pageController.jumpToPage(value.toInt());
                          },
                        ),
                      ));
                    }));
              }
            },
            child: CustomImageLoader(
                isLocal: data.isDownload,
                networkUrl:
                    data.imageUrls.isNotEmpty ? data.imageUrls[index] : "",
                localUrl:
                    data.localPaths.isNotEmpty ? data.localPaths[index] : ""),
          );
        });
  }
}
