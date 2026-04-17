import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
import 'package:tele_book/app/screen/book/screen/filter/book_filter_screen.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_screen.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_screen.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_screen.dart';
import 'package:tele_book/app/screen/export/export_screen.dart';
import 'package:tele_book/app/screen/home/home_screen.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_screen.dart';
import 'package:tele_book/app/screen/parse/image_folder/batch/parse_batch_image_folder_screen.dart';
import 'package:tele_book/app/screen/parse/image_folder/single/parse_image_folder_screen.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_screen.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_screen.dart';

class AppRoute {
  // ══════════════════════════════════════════════════════════════════════════
  // 路由常量定义
  // ══════════════════════════════════════════════════════════════════════════

  // 主页面
  static const home = '/home';
  static const book = '/book';
  static const export = '/export';
  static const collection = '/collection';
  static const mark = '/mark';

  // 书籍相关
  static const bookForm = '/book/form';
  static const bookEdit = '/book/edit';
  static const bookPage = '/book/page';
  static const bookFilter = '/book/filter';

  // 下载
  static const download = '/download';
  static const downloadTask = '/download/task';

  // 解析
  static const parseWeb = '/parse/web';
  static const parsePdf = '/parse/pdf';
  static const parseImageFolder = '/parse/image_folder';
  static const parseBatchImageFolder = '/parse/batch_image_folder';
  static const parseArchiveSingle = '/parse/archive/single';
  static const parseArchiveBatch = '/parse/archive/batch';
  static const parseArchiveBatchEdit = '/parse/archive/batch/edit';

  // Build a GoRouter instance. We still call Get Bindings when building each page
  // to keep existing dependency registration behavior.
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        pageBuilder: (context, state) {
          // 支持查询参数指定初始 tab
          final tab = state.uri.queryParameters['tab'];
          final taskTab = state.uri.queryParameters['taskTab'];

          return MaterialPage(
            child: HomeScreen(
              initialTab: int.tryParse(tab ?? ''),
              initialTaskTab: int.tryParse(taskTab ?? ''),
            ),
          );
        },
      ),
      GoRoute(
        path: book,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookScreen());
        },
      ),
      GoRoute(
        path: export,
        pageBuilder: (context, state) {
          return MaterialPage(child: ExportScreen());
        },
      ),
      GoRoute(
        path: bookForm,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookFormScreen());
        },
      ),
      GoRoute(
        path: bookEdit,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookEditScreen());
        },
      ),
      GoRoute(
        path: bookPage,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookPageScreen());
        },
      ),
      GoRoute(
        path: bookFilter,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookFilterScreen());
        },
      ),
      GoRoute(
        path: parseWeb,
        pageBuilder: (context, state) {
          final parseUrl = state.pathParameters['url'] ?? '';
          return MaterialPage(child: ParseWebScreen(parseUrl: parseUrl));
        },
      ),
      GoRoute(
        path: parsePdf,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParsePdfScreen());
        },
      ),
      GoRoute(
        path: parseImageFolder,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseImageFolderScreen());
        },
      ),
      GoRoute(
        path: parseBatchImageFolder,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseBatchImageFolderScreen());
        },
      ),
      GoRoute(
        path: parseArchiveSingle,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseSingleArchiveScreen());
        },
      ),
      GoRoute(
        path: parseArchiveBatch,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseBatchArchiveScreen());
        },
      ),
      GoRoute(
        path: parseArchiveBatchEdit,
        pageBuilder: (context, state) {
          return MaterialPage(child: EditArchiveFilesScreen());
        },
      ),
      GoRoute(
        path: download,
        pageBuilder: (context, state) {
          return MaterialPage(child: DownloadScreen());
        },
      ),
      GoRoute(
        path: downloadTask,
        pageBuilder: (context, state) {
          return MaterialPage(child: DownloadTaskScreen());
        },
      ),
      GoRoute(
        path: collection,
        pageBuilder: (context, state) {
          return MaterialPage(child: CollectionScreen());
        },
      ),
      GoRoute(
        path: mark,
        pageBuilder: (context, state) {
          return MaterialPage(child: MarkScreen());
        },
      ),
    ],
  );
}
