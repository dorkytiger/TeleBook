import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/reading_direction_enum.dart';
import 'package:tele_book/app/service/path_service.dart';

class BookPageController extends GetxController {
  final int bookId = Get.arguments as int;

  final appDatabase = Get.find<AppDatabase>();
  final pathService = Get.find<PathService>();

  // 书籍数据
  late BookTableData bookData;

  // 页面控制器
  late PageController pageController;

  // 滚动控制器（用于上下阅读模式）
  late ScrollController scrollController;

  // 当前页码（从 0 开始）
  final currentPage = 0.obs;

  // 总页数
  final totalPages = 0.obs;

  // 应用目录
  late String appDirectory;

  // 是否显示进度条
  final showProgress = true.obs;

  // 阅读方向设置
  final readingDirection = ReadingDirection.leftToRight.obs;

  // SharedPreferences
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _initializePreferences();
  }

  /// 初始化SharedPreferences和加载数据
  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadReadingSettings();
    await _loadBookData();
  }

  /// 加载阅读设置
  Future<void> _loadReadingSettings() async {
    final directionValue =
        prefs.getInt('reading_direction') ?? ReadingDirection.leftToRight.value;
    readingDirection.value = ReadingDirection.fromValue(directionValue);
  }

  /// 加载书籍数据
  Future<void> _loadBookData() async {
    try {
      appDirectory = (await getApplicationDocumentsDirectory()).path;

      // 从数据库加载书籍数据
      final book =
          await (appDatabase.bookTable.select()
                ..where((tbl) => tbl.id.equals(bookId)))
              .getSingle();

      bookData = book;
      totalPages.value = book.localPaths.length;

      // 设置当前页为保存的阅读进度
      currentPage.value = book.currentPage;

      // 初始化页面控制器，从保存的页面开始
      pageController = PageController(initialPage: currentPage.value);

      // 初始化滚动控制器
      scrollController = ScrollController();

      // 监听页面变化
      pageController.addListener(_onPageChanged);
      scrollController.addListener(_onScrollChanged);
    } catch (e) {
      debugPrint('Error loading book data: $e');
      Get.back();
    }
  }

  /// 页面变化回调
  void _onPageChanged() {
    if (pageController.hasClients) {
      final page = pageController.page?.round() ?? 0;
      if (page != currentPage.value) {
        currentPage.value = page;
        // 保存阅读进度到数据库
        _saveReadingProgress(page);
      }
    }
  }

  /// 滚动变化回调（用于上下阅读模式）
  void _onScrollChanged() {
    if (scrollController.hasClients &&
        readingDirection.value == ReadingDirection.topToBottom) {
      // 根据滚动位置计算当前页面（简单估算）
      final scrollRatio =
          scrollController.offset / scrollController.position.maxScrollExtent;
      final estimatedPage = (scrollRatio * (totalPages.value - 1)).round();
      if (estimatedPage != currentPage.value &&
          estimatedPage >= 0 &&
          estimatedPage < totalPages.value) {
        currentPage.value = estimatedPage;
        _saveReadingProgress(estimatedPage);
      }
    }
  }

  /// 保存阅读进度到数据库
  Future<void> _saveReadingProgress(int page) async {
    try {
      await (appDatabase.update(appDatabase.bookTable)
            ..where((tbl) => tbl.id.equals(bookId)))
          .write(BookTableCompanion(currentPage: drift.Value(page)));
      debugPrint('Saved reading progress: page $page for book $bookId');
    } catch (e) {
      debugPrint('Error saving reading progress: $e');
    }
  }

  /// 跳转到指定页
  void jumpToPage(int page) {
    if (page >= 0 && page < totalPages.value) {
      if (readingDirection.value == ReadingDirection.topToBottom) {
        // 上下阅读模式：滚动到对应位置
        if (scrollController.hasClients) {
          final scrollRatio = page / (totalPages.value - 1);
          final targetOffset =
              scrollRatio * scrollController.position.maxScrollExtent;
          scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // 左右阅读模式：跳转页面
        pageController.jumpToPage(page);
      }
    }
  }

  /// 上一页
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 下一页
  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 切换进度条显示
  void toggleProgress() {
    showProgress.value = !showProgress.value;
  }

  /// 显示阅读设置对话框
  void showReadingSettings(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, ts, tx) {
        return AlertDialog(
          title: Text('阅读设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('选择阅读方向：'),
              const SizedBox(height: 16),
              // TDRadioGroup(
              //   direction: Axis.vertical,
              //   selectId: readingDirection.value.value.toString(),
              //   onRadioGroupChange: (id) {
              //     final selectedDirection = ReadingDirection.values.firstWhere(
              //       (direction) => direction.value.toString() == id,
              //     );
              //     saveReadingDirection(selectedDirection);
              //   },
              //   directionalTdRadios: [
              //     ...ReadingDirection.values.map((direction) {
              //       return TDRadio(
              //         id: direction.value.toString(),
              //         title: direction.label,
              //       );
              //     }),
              //   ],
              // ),
            ],
          ),
          // rightBtn: TDDialogButtonOptions(
          //   title: '确定',
          //   action: () => Get.back(),
          // ),
        );
      },
    );
  }

  /// 保存阅读方向设置
  Future<void> saveReadingDirection(ReadingDirection direction) async {
    readingDirection.value = direction;
    await prefs.setInt('reading_direction', direction.value);

    // 根据阅读方向调整页面控制器
    _adjustPageControllerForDirection();
  }

  /// 根据阅读方向调整页面控制器
  void _adjustPageControllerForDirection() {
    // 保存当前页面
    final currentPageIndex = currentPage.value;

    // 如果PageController已经存在，先dispose
    if (pageController.hasClients) {
      pageController.removeListener(_onPageChanged);
      pageController.dispose();
    }

    // 如果ScrollController已经存在，先dispose
    if (scrollController.hasClients) {
      scrollController.removeListener(_onScrollChanged);
      scrollController.dispose();
    }

    // 重新创建控制器
    pageController = PageController(initialPage: currentPageIndex);
    pageController.addListener(_onPageChanged);

    scrollController = ScrollController();
    scrollController.addListener(_onScrollChanged);
  }

  @override
  void onClose() {
    // 保存最终的阅读进度
    _saveReadingProgress(currentPage.value);
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
