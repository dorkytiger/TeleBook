import 'dart:io';

import 'package:flutter/cupertino.dart';
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
      create: (context) => BookPageViewmodel(book: book),
      child: _BookPageContent(),
    );
  }
}

class _BookPageContent extends StatelessWidget {
  const _BookPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.sizeOf(context).width;
    final viewmodel = context.watch<BookPageViewmodel>();
    return Scaffold(
      appBar: AppBar(title: Text(viewmodel.book.name)),
      body: PageView.builder(
        itemBuilder: (context, index) {
          final page = viewmodel.paths[index];

          final boxWidth = fullWidth * 0.3;
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    viewmodel.toggleBar();
                  },
                  child: SizedBox(width: boxWidth, height: double.infinity),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.file(
                  File(page),
                  fit: BoxFit.contain,
                ),
              )
            ],
          );
        },
        itemCount: viewmodel.paths.length,
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: viewmodel.isShowBar
            ? LinearProgressIndicator(key: UniqueKey()) // 必须加 Key 才能触发动画
            : SizedBox.shrink(),
      ),
    );
  }
}
