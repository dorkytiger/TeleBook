import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/app/screen/book/book_screen.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_screen.dart';
import 'package:tele_book/app/screen/book/screen/filter/book_filter_screen.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_screen.dart';
import 'package:tele_book/app/screen/collection/collection_screen.dart';
import 'package:tele_book/app/screen/download/download_screen.dart';
import 'package:tele_book/app/screen/download/screen/task/download_task_screen.dart';
import 'package:tele_book/app/screen/export/export_screen.dart';
import 'package:tele_book/app/screen/home/home_screen.dart';
import 'package:tele_book/app/screen/mark/mark_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/screen/edit/edit_archive_files_screen.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_screen.dart';
import 'package:tele_book/app/screen/parse/form/parse_form_screen.dart';
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
  static const bookEdit = '/book/edit';
  static const bookPage = '/book/page';
  static const bookFilter = '/book/filter';

  // 下载
  static const download = '/download';
  static const downloadTask = '/download/task';

  // 解析
  static const parseForm = '/parse/form';
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
        path: bookEdit,
        pageBuilder: (context, state) {
          final bookId = state.pathParameters['id'];
          if (bookId == null) {
            return MaterialPage(child: ErrorRoutePage(message: '缺少书籍ID参数'));
          }
          final parsedBookId = int.tryParse(bookId);
          if (parsedBookId == null) {
            return MaterialPage(child: ErrorRoutePage(message: '无效的书籍ID参数'));
          }
          return MaterialPage(child: BookEditScreen(bookId: parsedBookId));
        },
      ),
      GoRoute(
        path: bookPage,
        pageBuilder: (context, state) {
          final bookId = state.pathParameters['id'];
          if (bookId == null) {
            return MaterialPage(child: ErrorRoutePage(message: '缺少书籍ID参数'));
          }
          final parsedBookId = int.tryParse(bookId);
          if (parsedBookId == null) {
            return MaterialPage(child: ErrorRoutePage(message: '无效的书籍ID参数'));
          }
          return MaterialPage(child: BookPageScreen(bookId: parsedBookId));
        },
      ),
      GoRoute(
        path: bookFilter,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookFilterScreen());
        },
      ),
      GoRoute(
        path: parseForm,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseFormScreen());
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
          final path = state.extra as String? ?? '';
          return MaterialPage(child: ParsePdfScreen(pdfPath: path));
        },
      ),
      GoRoute(
        path: parseImageFolder,
        pageBuilder: (context, state) {
          final path = state.extra as String? ?? '';
          return MaterialPage(child: ParseImageFolderScreen(folderPath: path));
        },
      ),
      GoRoute(
        path: parseBatchImageFolder,
        pageBuilder: (context, state) {
          final path = state.extra as String? ?? '';
          return MaterialPage(
            child: ParseBatchImageFolderScreen(parentFolderPath: path),
          );
        },
      ),
      GoRoute(
        path: parseArchiveSingle,
        pageBuilder: (context, state) {
          final path = state.extra as String? ?? '';
          return MaterialPage(child: ParseSingleArchiveScreen(filePath: path));
        },
      ),
      GoRoute(
        path: parseArchiveBatch,
        pageBuilder: (context, state) {
          final path = state.extra as String? ?? '';
          return MaterialPage(child: ParseBatchArchiveScreen(folderPath: path));
        },
      ),
      GoRoute(
        path: parseArchiveBatchEdit,
        pageBuilder: (context, state) {
          final archiveFolder = state.extra as ArchiveFolder;
          return MaterialPage(
            child: EditArchiveFilesScreen(archiveFolder: archiveFolder),
          );
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
          final groupId = state.extra as String? ?? '';
          return MaterialPage(child: DownloadTaskScreen(groupId: groupId));
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

// 专门处理导航失败（如缺少参数的页面）
class ErrorRoutePage extends StatelessWidget {
  final String message;

  const ErrorRoutePage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("导航错误"),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Text(message, style: TextStyle(fontSize: 18, color: Colors.red)),
      ),
    );
  }
}
