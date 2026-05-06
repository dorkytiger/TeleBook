import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/viewmodel/book_page_viewmodel.dart';

class BookPageView extends StatelessWidget {
  final BookTableData book;

  const BookPageView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          BookPageViewmodel(book: book, bookService: context.read()),
      child: _BookPageContent(),
    );
  }
}

class _BookPageContent extends StatelessWidget {
  const _BookPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.sizeOf(context).width;
    final boxWidth = fullWidth / 3;
    final viewmodel = context.watch<BookPageViewmodel>();
    return Scaffold(
      appBar: AppBar(title: Text(viewmodel.book.name)),
      body: Stack(
        children: [
          PageView.builder(
            controller: viewmodel.pageController,
            onPageChanged: viewmodel.onPageChanged,
            itemBuilder: (context, index) {
              final page = viewmodel.paths[index];
              return Image.file(File(page), fit: BoxFit.contain);
            },
            itemCount: viewmodel.paths.length,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: viewmodel.toggleBar,
                child: SizedBox(width: boxWidth, height: double.infinity),
              ),
            ),
          ),
          Positioned.fill(

            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: viewmodel.isShowBar && viewmodel.paths.isNotEmpty
                  ? Container(
                key: const ValueKey<String>('progress_slider'),
                height: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text('${viewmodel.currentPage + 1}'),
                    Expanded(
                      child: Slider(
                        value: viewmodel.currentPage.toDouble(),
                        min: 0,
                        max: (viewmodel.paths.length - 1).toDouble(),
                        divisions: viewmodel.paths.length > 1
                            ? viewmodel.paths.length - 1
                            : 1,
                        onChanged: (value) {
                          viewmodel.jumpToPage(value.toInt());
                        },
                      ),
                    ),
                    Text('${viewmodel.paths.length}'),
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
