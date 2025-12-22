import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_binding.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_binding.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_screen.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_binding.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_screen.dart';
import 'package:tele_book/app/screen/download/download_binding.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_binding.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_screen.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_binding.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_screen.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_binding.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_screen.dart';

class AppRoute {
  static final pages = [
    GetPage(name: '/book', page: () => BookScreen(), binding: BookBinding()),
    GetPage(
      name: '/book/form',
      page: () => BookFormScreen(),
      binding: BookFormBinding(),
    ),
    GetPage(
      name: '/book/edit',
      page: () => BookEditScreen(),
      binding: BookEditBinding(),
    ),
    GetPage(
      name: '/book/page',
      page: () => BookPageScreen(),
      binding: BookPageBinding(),
    ),
    GetPage(
      name: '/parse/web',
      page: () => ParseWebScreen(),
      binding: ParseWebBinding(),
    ),
    GetPage(
      name: '/parse/archive/single',
      page: () => ParseSingleArchiveScreen(),
      binding: ParseSingleArchiveBinding(),
    ),
    GetPage(
      name: '/parse/archive/batch',
      page: () => ParseBatchArchiveScreen(),
      binding: ParseBatchArchiveBinding(),
    ),
    GetPage(
      name: '/parse/archive/batch/edit',
      page: () => EditArchiveFilesScreen(),
      binding: EditArchiveFilesBinding(),
    ),
    GetPage(
      name: '/download',
      page: () => DownloadScreen(),
      binding: DownloadBinding(),
    ),
    GetPage(
      name: '/download/form',
      page: () => DownloadFormScreen(),
      binding: DownloadFormBinding(),
    ),
    GetPage(
      name: '/download/task',
      page: () => DownloadTaskScreen(),
      binding: DownloadTaskBinding(),
    ),
  ];
}
