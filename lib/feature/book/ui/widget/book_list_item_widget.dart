import 'dart:io';

import 'package:tele_book/feature/book/model/vo/book_vo.dart';
import 'package:flutter/material.dart';

class BookListItemWidget extends StatelessWidget {
  final BookListItemVo bookListItemVo;

  const BookListItemWidget({super.key, required this.bookListItemVo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(
        File(bookListItemVo.coverImagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(bookListItemVo.book.name),
      subtitle: Text(bookListItemVo.book.createdAt.toIso8601String()),
    );
  }
}
