import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';

class BookPageController extends GetxController {
  final int bookId = Get.arguments as int;

  final appDatabase = Get.find<AppDatabase>();

  // 书籍数据
  late BookTableData bookData;

  // 页面控制器
  late PageController pageController;

  // 当前页码（从 0 开始）
  final currentPage = 0.obs;

  // 总页数
  final totalPages = 0.obs;

  // 应用目录
  late String appDirectory;

  // 是否显示进度条
  final showProgress = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookData();
  }

  /// 加载书籍数据
  Future<void> _loadBookData() async {
    try {
      appDirectory = (await getApplicationDocumentsDirectory()).path;

      // 从数据库加载书籍数据
      final book = await (appDatabase.bookTable.select()
            ..where((tbl) => tbl.id.equals(bookId)))
          .getSingle();

      bookData = book;
      totalPages.value = book.localPaths.length;

      // 初始化页面控制器
      pageController = PageController(initialPage: currentPage.value);

      // 监听页面变化
      pageController.addListener(_onPageChanged);
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
      }
    }
  }

  /// 跳转到指定页
  void jumpToPage(int page) {
    if (page >= 0 && page < totalPages.value) {
      pageController.jumpToPage(page);
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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

