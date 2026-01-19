import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_binding.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_binding.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_screen.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_binding.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_screen.dart';
import 'package:tele_book/app/screen/collection/collection_bind.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/download/download_binding.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_binding.dart';
import 'package:tele_book/app/screen/download/screen/form/download_form_screen.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_binding.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_screen.dart';
import 'package:tele_book/app/screen/home/home_bind.dart';
import 'package:tele_book/app/screen/home/home_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_screen.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_binding.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_screen.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_binding.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_screen.dart';

class AppRoute {
  static const home = "/home";

  static const book = "/book";
  static const bookForm = "/book/form";
  static const bookEdit = "/book/edit";
  static const bookPage = "/book/page";

  static const parseWeb = "/parse/web";
  static const parsePdf = "/parse/pdf";
  static const parseArchiveSingle = "/parse/archive/single";
  static const parseArchiveBatch = "/parse/archive/batch";
  static const parseArchiveBatchEdit = "/parse/archive/batch/edit";

  static const download = "/download";
  static const downloadForm = "/download/form";
  static const downloadTask = "/download/task";

  static const collection = "/collection";

  static final pages = [
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBind()),
    GetPage(name: book, page: () => BookScreen(), binding: BookBinding()),
    GetPage(
      name: bookForm,
      page: () => BookFormScreen(),
      binding: BookFormBinding(),
    ),
    GetPage(
      name: bookEdit,
      page: () => BookEditScreen(),
      binding: BookEditBinding(),
    ),
    GetPage(
      name: bookPage,
      page: () => BookPageScreen(),
      binding: BookPageBinding(),
    ),
    GetPage(
      name: parseWeb,
      page: () => ParseWebScreen(),
      binding: ParseWebBinding(),
    ),
    GetPage(
      name: parsePdf,
      page: () => ParsePdfScreen(),
      binding: ParsePdfBinding(),
    ),
    GetPage(
      name: parseArchiveSingle,
      page: () => ParseSingleArchiveScreen(),
      binding: ParseSingleArchiveBinding(),
    ),
    GetPage(
      name: parseArchiveBatch,
      page: () => ParseBatchArchiveScreen(),
      binding: ParseBatchArchiveBinding(),
    ),
    GetPage(
      name: parseArchiveBatchEdit,
      page: () => EditArchiveFilesScreen(),
      binding: EditArchiveFilesBinding(),
    ),
    GetPage(
      name: download,
      page: () => DownloadScreen(),
      binding: DownloadBinding(),
    ),
    GetPage(
      name: downloadForm,
      page: () => DownloadFormScreen(),
      binding: DownloadFormBinding(),
    ),
    GetPage(
      name: downloadTask,
      page: () => DownloadTaskScreen(),
      binding: DownloadTaskBinding(),
    ),
    GetPage(
      name: collection,
      page: () => CollectionScreen(),
      binding: CollectionBind(),
    ),
  ];
}
