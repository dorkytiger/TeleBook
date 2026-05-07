import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/view/book_form_view.dart';
import 'package:tele_book/feature/book/ui/view/book_page_view.dart';
import 'package:tele_book/feature/book/ui/view/book_view.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/export/ui/view/export_batch_form_view.dart';
import 'package:tele_book/feature/export/ui/view/export_single_form_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_archive_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_archive_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_image_folder_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_pdf_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_form_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_image_folder_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_pdf_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_web_view.dart';

class AppRoute {
  // 主页面
  static const book = '/book';

  // 导出
  static const exportSingle = '/export/single';
  static const exportBatch = '/export/batch';

  // 书籍相关
  static const bookForm = '/book/form';
  static const bookPage = '/book/page';

  // 下载
  static const download = '/download';

  // 解析
  static const parseForm = '/parse/form';
  static const parseWeb = '/parse/web';
  static const parsePdf = '/parse/pdf';
  static const parseBatchPdf = '/parse/batch_pdf';
  static const parseImageFolder = '/parse/image_folder';
  static const parseBatchImageFolder = '/parse/batch_image_folder';
  static const parseArchiveSingle = '/parse/archive/single';
  static const parseArchiveBatch = '/parse/archive/batch';
  static const parseArchiveBatchEdit = '/parse/archive/batch/edit';

  static final GoRouter router = GoRouter(
    initialLocation: book,
    routes: [
      GoRoute(
        path: book,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookView());
        },
      ),
      GoRoute(
        path: bookForm,
        pageBuilder: (context, state) {
          final book = state.extra as BookTableData?;
          if (book == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少书籍参数"));
          }
          return MaterialPage(child: BookFormView(book: book));
        },
      ),
      GoRoute(
        path: bookPage,
        pageBuilder: (context, state) {
          final book = state.extra as BookTableData?;
          if (book == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少书籍参数"));
          }
          return MaterialPage(child: BookPageView(book: book));
        },
      ),
      GoRoute(
        path: download,
        pageBuilder: (context, state) {
          return MaterialPage(child: Scaffold(body: DownloadListView()));
        },
      ),
      GoRoute(
        path: exportSingle,
        pageBuilder: (context, state) {
          final book = state.extra as BookTableData?;
          if (book == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少书籍参数"));
          }
          return MaterialPage(child: ExportSingleFormView(book: book));
        },
      ),
      GoRoute(
        path: exportBatch,
        pageBuilder: (context, state) {
          final books = state.extra as List<BookTableData>?;
          if (books == null || books.isEmpty) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少书籍参数"));
          }
          return MaterialPage(child: ExportBatchFormView(books: books));
        },
      ),
      GoRoute(
        path: parseForm,
        pageBuilder: (context, state) {
          return MaterialPage(child: ParseFormView());
        },
      ),
      GoRoute(
        path: parseWeb,
        pageBuilder: (context, state) {
          final url = state.extra as String?;
          if (url == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少URL参数"));
          }
          return MaterialPage(child: ParseWebView(url: url));
        },
      ),
      GoRoute(
        path: parseImageFolder,
        pageBuilder: (context, state) {
          final folderPath = state.extra as String?;
          if (folderPath == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少文件夹路径参数"));
          }
          return MaterialPage(child: ParseImageFolderView(folderPath: folderPath));
        },
      ),
      GoRoute(
        path: parseBatchImageFolder,
        pageBuilder: (context, state) {
          final parentDirPath = state.extra as String?;
          if (parentDirPath == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少父目录路径参数"));
          }
          return MaterialPage(
            child: ParseBatchImageFolderView(parentDirPath: parentDirPath),
          );
        },
      ),
      GoRoute(
        path: parseArchiveSingle,
        pageBuilder: (context, state) {
          final path = state.extra as String?;
          if (path == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少文件路径参数"));
          }
          return MaterialPage(child: ParseArchiveView(archivePath: path));
        },
      ),
      GoRoute(
        path: parseArchiveBatch,
        pageBuilder: (context, state) {
          final archiveDirPath = state.extra as String?;
          if (archiveDirPath == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少文件夹路径参数"));
          }
          return MaterialPage(
            child: ParseBatchArchiveView(archiveDirPath: archiveDirPath),
          );
        },
      ),
      GoRoute(
        path: parsePdf,
        pageBuilder: (context, state) {
          final path = state.extra as String?;
          if (path == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少 PDF 文件路径参数"));
          }
          return MaterialPage(child: ParsePdfView(pdfPath: path));
        },
      ),
      GoRoute(
        path: parseBatchPdf,
        pageBuilder: (context, state) {
          final dirPath = state.extra as String?;
          if (dirPath == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少文件夹路径参数"));
          }
          return MaterialPage(child: ParseBatchPdfView(pdfDirPath: dirPath));
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
