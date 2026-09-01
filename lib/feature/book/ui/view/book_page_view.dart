import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_page_provider.dart';
import 'package:tele_book/feature/setting/enum/setting_key_value.dart';
import 'package:tele_book/feature/setting/ui/provider/setting_provider.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

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

  /// 书籍副本（initState 缓存；dispose 兜底保存时 provider 状态已不可靠）。
  late BookTableData _book;

  /// 同步服务（缓存引用：dispose 后 ref 不可用，兜底保存仍要写库）。
  late final SyncMutationService _syncMutation;

  /// 阅读进度防抖保存：翻页停止 [debounce] 后才落库 + 入队同步，
  /// 避免高频翻页产生大量 outbox 任务（同书任务还会被合并）。
  Timer? _saveTimer;
  int _savedPage = -1;
  static const _debounce = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(bookPageProvider(widget.book.id).notifier);
    final state = ref.read(bookPageProvider(widget.book.id));
    final initialPage = state.currentPage;
    _currentPage = initialPage;
    _savedPage = initialPage; // 初始页视为已保存，避免无谓写入
    _book = state.book;
    _syncMutation = ref.read(syncMutationServiceProvider);
    _pageController = PageController(initialPage: initialPage);
    notifier.initController(_pageController);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    unawaited(_saveProgress(_currentPage)); // 离开页面兜底保存最新进度
    _pageController.dispose();
    super.dispose();
  }

  /// 防抖保存阅读进度：本地立即更新 currentPage 并合并进同步任务。
  Future<void> _saveProgress(int page) async {
    if (page == _savedPage) return;
    _savedPage = page;
    await _syncMutation.enqueueBookProgress(
      book: _book.copyWith(currentPage: page),
    );
  }

  void _scheduleSave(int page) {
    _saveTimer?.cancel();
    _saveTimer = Timer(_debounce, () => _saveProgress(page));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookPageProvider(widget.book.id));
    final notifier = ref.watch(bookPageProvider(widget.book.id).notifier);
    final totalPages = state.paths.length;

    // 阅读方向：从左到右 / 从右到左（reverse 水平）/ 从上到下（垂直）
    final direction =
        ref.watch(readingDirectionSettingProvider).value ??
        ReadingDirection.leftToRight;
    final scrollDirection =
        direction == ReadingDirection.topToBottom
            ? Axis.vertical
            : Axis.horizontal;
    final reverse = direction == ReadingDirection.rightToLeft;

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
            _scheduleSave(page); // 停止翻页 800ms 后落库 + 同步
            return true;
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: scrollDirection,
          reverse: reverse,
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
