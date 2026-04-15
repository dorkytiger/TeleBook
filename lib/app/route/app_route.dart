import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/app/service/navigator_service.dart';
import 'package:tele_book/app/screen/book/book_binding.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_binding.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
import 'package:tele_book/app/screen/book/screen/filter/book_filter_binding.dart';
import 'package:tele_book/app/screen/book/screen/filter/book_filter_screen.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_binding.dart';
import 'package:tele_book/app/screen/book/screen/form/book_form_screen.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_binding.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_screen.dart';
import 'package:tele_book/app/screen/collection/collection_bind.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/download/download_binding.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_binding.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_screen.dart';
import 'package:tele_book/app/screen/export/export_binding.dart';
import 'package:tele_book/app/screen/export/export_screen.dart';
import 'package:tele_book/app/screen/home/home_bind.dart';
import 'package:tele_book/app/screen/home/home_screen.dart';
import 'package:tele_book/app/screen/mark/mark_bind.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_binding.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_screen.dart';
import 'package:tele_book/app/screen/parse/image_folder/batch/parse_batch_image_folder_binding.dart';
import 'package:tele_book/app/screen/parse/image_folder/batch/parse_batch_image_folder_screen.dart';
import 'package:tele_book/app/screen/parse/image_folder/single/parse_image_folder_binding.dart';
import 'package:tele_book/app/screen/parse/image_folder/single/parse_image_folder_screen.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_binding.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_screen.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_binding.dart';
import 'package:tele_book/app/screen/parse/web/parse_web_screen.dart';

class AppRoute {
  // Define string paths for easy reuse
  static const home = '/home';
  static const book = '/book';
  static const bookForm = '/book/form';
  static const bookEdit = '/book/edit';
  static const bookPage = '/book/page';
  static const bookFilter = '/book/filter';
  static const export = '/export';

  // Build a GoRouter instance. We still call Get Bindings when building each page
  // to keep existing dependency registration behavior.
  static final GoRouter router = GoRouter(
    navigatorKey: NavigatorService.navigatorKey,
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        pageBuilder: (context, state) {
          HomeBind().dependencies();
          return MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        path: book,
        pageBuilder: (context, state) {
          BookBinding().dependencies();
          return MaterialPage(child: BookScreen());
        },
      ),
      GoRoute(
        path: export,
        pageBuilder: (context, state) {
          ExportBinding().dependencies();
          return MaterialPage(child: ExportScreen());
        },
      ),
      GoRoute(
        path: bookForm,
        pageBuilder: (context, state) {
          BookFormBinding().dependencies();
          return MaterialPage(child: BookFormScreen());
        },
      ),
      GoRoute(
        path: bookEdit,
        pageBuilder: (context, state) {
          BookEditBinding().dependencies();
          return MaterialPage(child: BookEditScreen());
        },
      ),
      GoRoute(
        path: bookPage,
        pageBuilder: (context, state) {
          BookPageBinding().dependencies();
          return MaterialPage(child: BookPageScreen());
        },
      ),
      GoRoute(
        path: bookFilter,
        pageBuilder: (context, state) {
          BookFilterBinding().dependencies();
          return MaterialPage(child: BookFilterScreen());
        },
      ),
      GoRoute(
        path: '/parse/web',
        pageBuilder: (context, state) {
          ParseWebBinding().dependencies();
          return MaterialPage(child: ParseWebScreen());
        },
      ),
      GoRoute(
        path: '/parse/pdf',
        pageBuilder: (context, state) {
          ParsePdfBinding().dependencies();
          return MaterialPage(child: ParsePdfScreen());
        },
      ),
      GoRoute(
        path: '/parse/image_folder',
        pageBuilder: (context, state) {
          ParseImageFolderBinding().dependencies();
          return MaterialPage(child: ParseImageFolderScreen());
        },
      ),
      GoRoute(
        path: '/parse/batch_image_folder',
        pageBuilder: (context, state) {
          ParseBatchImageFolderBinding().dependencies();
          return MaterialPage(child: ParseBatchImageFolderScreen());
        },
      ),
      GoRoute(
        path: '/parse/archive/single',
        pageBuilder: (context, state) {
          ParseSingleArchiveBinding().dependencies();
          return MaterialPage(child: ParseSingleArchiveScreen());
        },
      ),
      GoRoute(
        path: '/parse/archive/batch',
        pageBuilder: (context, state) {
          ParseBatchArchiveBinding().dependencies();
          return MaterialPage(child: ParseBatchArchiveScreen());
        },
      ),
      GoRoute(
        path: '/parse/archive/batch/edit',
        pageBuilder: (context, state) {
          EditArchiveFilesBinding().dependencies();
          return MaterialPage(child: EditArchiveFilesScreen());
        },
      ),
      GoRoute(
        path: '/download',
        pageBuilder: (context, state) {
          DownloadBinding().dependencies();
          return MaterialPage(child: DownloadScreen());
        },
      ),
      GoRoute(
        path: '/download/task',
        pageBuilder: (context, state) {
          DownloadTaskBinding().dependencies();
          return MaterialPage(child: DownloadTaskScreen());
        },
      ),
      GoRoute(
        path: '/collection',
        pageBuilder: (context, state) {
          CollectionBind().dependencies();
          return MaterialPage(child: CollectionScreen());
        },
      ),
      GoRoute(
        path: '/mark',
        pageBuilder: (context, state) {
          MarkBind().dependencies();
          return MaterialPage(child: MarkScreen());
        },
      ),
    ],
  );
}
