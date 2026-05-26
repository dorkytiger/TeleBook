import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_page_provider.dart';

class BookPageView extends ConsumerWidget {
  final BookTableData book;

  const BookPageView({super.key, required this.book});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final state =ref.watch(bookPageProvider(book.id));
    final notifier = ref.watch(bookPageProvider(book.id).notifier);

    final fullWidth = MediaQuery.sizeOf(context).width;
    final boxWidth = fullWidth / 3;
    return Scaffold(
      appBar: AppBar(title: Text(state.book.name)),
      body: Stack(
        children: [
          PageView.builder(
            controller: notifier.pageController,
            onPageChanged: notifier.onPageChanged,
            itemBuilder: (context, index) {
              final page = state.paths[index];
              return Image.file(File(page), fit: BoxFit.contain);
            },
            itemCount: state.paths.length,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: notifier.toggleBar,
                child: SizedBox(width: boxWidth, height: double.infinity),
              ),
            ),
          ),
          Positioned.fill(

            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isShowBar && state.paths.isNotEmpty
                  ? Container(
                key: const ValueKey<String>('progress_slider'),
                height: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text('${state.currentPage + 1}'),
                    Expanded(
                      child: Slider(
                        value: state.currentPage.toDouble(),
                        min: 0,
                        max: (state.paths.length - 1).toDouble(),
                        divisions: state.paths.length > 1
                            ? state.paths.length - 1
                            : 1,
                        onChanged: (value) {
                          notifier.jumpToPage(value.toInt());
                        },
                      ),
                    ),
                    Text('${state.paths.length}'),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),),
          ),
        ],
      ),
    );
  }
}
