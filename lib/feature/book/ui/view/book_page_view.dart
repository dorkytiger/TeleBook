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
  late final FPaginationController _paginationController;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(bookPageProvider(widget.book.id).notifier);
    final state = ref.read(bookPageProvider(widget.book.id));
    final initialPage = state.currentPage;
    _pageController = PageController(initialPage: initialPage);
    _paginationController = FPaginationController(
      pages: state.paths.length - 1,
      siblings: 0,
    );
    _paginationController.value = initialPage;
    notifier.initController(_pageController);
  }

  @override
  void dispose() {
    _paginationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange(int page) {
    final old = _pageController.page?.round();
    if (old == null || old == page) return;
    if (page == old + 1 || page == old - 1) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else {
      _pageController.jumpToPage(page);
    }
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookPageProvider(widget.book.id));
    final notifier = ref.watch(bookPageProvider(widget.book.id).notifier);

    return FScaffold(
      header: FHeader.nested(
        title: Text(state.book.name),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(16),
        child: FPagination(
          style: .delta(
            itemConstraints: const BoxConstraints.tightFor(
              width: 32,
              height: 32,
            ),
          ),
          control: FPaginationControl.managed(
            controller: _paginationController,
            onChange: _handlePageChange,
          ),
        ),
      ),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          if (_pageController.hasClients) {
            _paginationController.value = _pageController.page!.round();
            notifier.onPageChanged(_pageController.page!.round());
            return true;
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: state.paths.length,
          itemBuilder: (context, index) {
            final page = state.paths[index];
            return Image.file(File(page), fit: BoxFit.contain);
          },
        ),
      ),
    );
  }
}
