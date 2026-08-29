import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_page_provider.dart';

class BookPageView extends ConsumerStatefulWidget {
  final BookTableData book;

  const BookPageView({super.key, required this.book});

  @override
  ConsumerState<BookPageView> createState() => _BookPageViewState();
}

class _BookPageViewState extends ConsumerState<BookPageView> {
  late final PageController _pageController;

  /// 当前页码（本地状态，滑块 Lifted 控制的唯一数据源）。
  ///
  /// 滑块完全由 [_currentPage] 推导的 value 驱动（ProxyController），
  /// 用户交互经 onChange 回写，不存在内部状态脱节的问题。
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(bookPageProvider(widget.book.id).notifier);
    final state = ref.read(bookPageProvider(widget.book.id));
    final initialPage = state.currentPage;
    _currentPage = initialPage;
    _pageController = PageController(initialPage: initialPage);
    notifier.initController(_pageController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookPageProvider(widget.book.id));
    final notifier = ref.watch(bookPageProvider(widget.book.id).notifier);
    final totalPages = state.paths.length;

    return FScaffold(
      header: FHeader.nested(
        title: Text(state.book.name),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            // 左侧：当前页码
            Text('${_currentPage + 1}'),
            const SizedBox(width: 12),
            Expanded(
              child: FSlider(
                control: FSliderControl.liftedContinuous(
                  value: FSliderValue(
                    max: totalPages <= 1
                        ? 0
                        : _currentPage / (totalPages - 1),
                  ),
                  onChange: (value) {
                    if (totalPages <= 1) return;
                    final page = (value.max * (totalPages - 1))
                        .round()
                        .clamp(0, totalPages - 1);
                    // Lifted 模式下重建也会回调 onChange，用页码相等拦截
                    if (page == _currentPage) return;
                    setState(() => _currentPage = page);
                    if (_pageController.hasClients) {
                      _pageController.jumpToPage(page);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 右侧：总页数
            Text('$totalPages'),
          ],
        ),
      ),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          if (_pageController.hasClients) {
            final page = _pageController.page!.round();
            setState(() => _currentPage = page);
            notifier.onPageChanged(page);
            return true;
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: totalPages,
          itemBuilder: (context, index) {
            final page = state.paths[index];
            return Image.file(File(page), fit: BoxFit.contain);
          },
        ),
      ),
    );
  }
}
