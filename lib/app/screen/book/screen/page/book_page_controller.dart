import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/reading_direction_enum.dart';
import 'package:tele_book/app/store/book_store.dart';

class BookPageController extends ChangeNotifier {
  final int bookId;
  final SharedPreferences sharedPreferences;
  final BookStore bookStore;

  // 页面控制器
  late PageController pageController;

  // 滚动控制器（用于上下阅读模式）
  late ScrollController scrollController;

  // 当前页码（从 0 开始）
  int currentPage = 0;

  // 总页数
  int totalPages = 0;

  // 应用目录
  late String appDirectory;

  // 是否显示进度条
  bool showProgress = true;
  BookTableData? _bookData;

  BookTableData? get bookData => _bookData;

  // 阅读方向设置
  ReadingDirection readingDirection = ReadingDirection.leftToRight;

  BookPageController({
    required this.bookId,
    required this.bookStore,
    required this.sharedPreferences,
  }) {
    //监听书籍数据变化，自动刷新页面
    bookStore.addListener(_onBookDataChanged);

    _loadReadingSettings();
    _loadBookData();
  }

  void _onBookDataChanged() {
    final book = bookStore.items.firstWhere((b) => b.id == bookId);
    _bookData = book;
    totalPages = book.localPaths.length;
    notifyListeners();
  }

  /// 加载阅读设置
  Future<void> _loadReadingSettings() async {
    final directionValue =
        sharedPreferences.getInt('reading_direction') ??
        ReadingDirection.leftToRight.value;
    readingDirection = ReadingDirection.fromValue(directionValue);
    notifyListeners();
  }

  /// 加载书籍数据
  Future<void> _loadBookData() async {
    try {
      // 从数据库加载书籍数据
      final book = await bookStore.getBookById(bookId);
      if (book == null) {
        throw Exception('Book not found with id $bookId');
      }

      _bookData = book;

      totalPages = book.localPaths.length;

      // 设置当前页为保存的阅读进度
      currentPage = book.currentPage;

      // 初始化页面控制器，从保存的页面开始
      pageController = PageController(initialPage: currentPage);

      // 初始化滚动控制器
      scrollController = ScrollController();

      // 监听页面变化
      pageController.addListener(_onPageChanged);
      scrollController.addListener(_onScrollChanged);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading book data: $e');
    }
  }

  /// 页面变化回调
  void _onPageChanged() {
    if (pageController.hasClients) {
      final page = pageController.page?.round() ?? 0;
      if (page != currentPage) {
        currentPage = page;
        // 保存阅读进度到数据库
        bookStore.saveReadProgress(bookId, page);
      }
    }
  }

  /// 滚动变化回调（用于上下阅读模式）
  void _onScrollChanged() {
    if (scrollController.hasClients &&
        readingDirection == ReadingDirection.topToBottom) {
      // 根据滚动位置计算当前页面（简单估算）
      final scrollRatio =
          scrollController.offset / scrollController.position.maxScrollExtent;
      final estimatedPage = (scrollRatio * (totalPages - 1)).round();
      if (estimatedPage != currentPage &&
          estimatedPage >= 0 &&
          estimatedPage < totalPages) {
        currentPage = estimatedPage;
        bookStore.saveReadProgress(bookId, estimatedPage);
      }
      notifyListeners();
    }
  }

  /// 跳转到指定页
  void jumpToPage(int page) {
    if (page >= 0 && page < totalPages) {
      if (readingDirection == ReadingDirection.topToBottom) {
        // 上下阅读模式：滚动到对应位置
        if (scrollController.hasClients) {
          final scrollRatio = page / (totalPages - 1);
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
    notifyListeners();
  }

  /// 上一页
  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 下一页
  void nextPage() {
    if (currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 切换进度条显示
  void toggleProgress() {
    showProgress = !showProgress;
    notifyListeners();
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
              RadioGroup<ReadingDirection>(
                onChanged: (value) {
                  if (value != null) {
                    saveReadingDirection(value);
                  }
                },
                groupValue: readingDirection,
                child: Column(
                  children: [
                    RadioListTile(
                      value: ReadingDirection.leftToRight,
                      selected:
                          readingDirection == ReadingDirection.leftToRight,
                      title: Text('左右阅读'),
                    ),
                    RadioListTile(
                      value: ReadingDirection.topToBottom,
                      selected:
                          readingDirection == ReadingDirection.topToBottom,
                      title: Text('上下阅读'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 保存阅读方向设置
  Future<void> saveReadingDirection(ReadingDirection direction) async {
    readingDirection = direction;
    await sharedPreferences.setInt('reading_direction', direction.value);
    // 根据阅读方向调整页面控制器
    _adjustPageControllerForDirection();
    notifyListeners();
  }

  /// 根据阅读方向调整页面控制器
  void _adjustPageControllerForDirection() {
    // 保存当前页面
    final currentPageIndex = currentPage;

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
}
