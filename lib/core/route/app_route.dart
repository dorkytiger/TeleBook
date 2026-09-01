import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/view/book_form_view.dart';
import 'package:tele_book/feature/book/ui/view/book_page_view.dart';
import 'package:tele_book/feature/book/ui/view/book_picker_view.dart';
import 'package:tele_book/feature/collection/ui/view/collection_book_view.dart';
import 'package:tele_book/feature/download/ui/view/download_list_view.dart';
import 'package:tele_book/feature/export/ui/view/export_batch_form_view.dart';
import 'package:tele_book/feature/export/ui/view/export_single_form_view.dart';
import 'package:tele_book/feature/main/view/main_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_archive_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_archive_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_image_folder_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_batch_pdf_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_form_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_image_folder_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_pdf_view.dart';
import 'package:tele_book/feature/parse/ui/view/parse_web_view.dart';
import 'package:tele_book/feature/setting/ui/view/sync_server_view.dart';
import 'package:tele_book/feature/sync/ui/view/sync_books_view.dart';
import 'package:tele_book/feature/sync/ui/view/sync_history_detail_view.dart';
import 'package:tele_book/feature/sync/ui/provider/sync_history_provider.dart';
import 'package:tele_book/feature/sync/ui/view/sync_history_view.dart';
import 'package:tele_book/feature/sync/ui/view/sync_download_view.dart';
import 'package:tele_book/feature/sync/ui/view/sync_log_detail_view.dart';
import 'package:tele_book/feature/sync/ui/view/sync_log_list_view.dart';

class AppRoute {
  // 主页面
  static const main = '/main';

  // 导出
  static const exportSingle = '/export/single';
  static const exportBatch = '/export/batch';

  // 书籍相关
  static const bookForm = '/book/form';
  static const bookPage = '/book/page';
  static const bookPicker = '/book/picker';

  // 下载
  static const download = '/download';


  static const collection = '/collection';
  static const collectionBook = '/collection/book';

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

  // 设置
  static const syncServer = '/setting/sync_server';
  static const syncBooks = '/setting/sync_books';
  static const syncHistory = '/setting/sync_history';
  static const syncHistoryDetail = '/setting/sync_history/detail';
  static const syncLogList = '/setting/sync_log';
  static const syncLogDetail = '/setting/sync_log/detail';
  static const syncDownload = '/setting/sync_download';

  static final GoRouter router = GoRouter(
    initialLocation: main,
    routes: [
      GoRoute(
        path: main,
        pageBuilder: (context, state) {
          return MaterialPage(child: MainView());
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
        path: bookPicker,
        pageBuilder: (context, state) {
          final extra = state.extra;
          Set<int> disabledBookIds = <int>{};
          if (extra is List<int>) {
            disabledBookIds = extra.toSet();
          } else if (extra is Set<int>) {
            disabledBookIds = extra;
          } else if (extra is List) {
            disabledBookIds = extra.whereType<int>().toSet();
          }
          return MaterialPage(
            child: BookPickerView(disabledBookIds: disabledBookIds),
          );
        },
      ),
      GoRoute(
        path: download,
        pageBuilder: (context, state) {
          return MaterialPage(child: Scaffold(body: DownloadListView()));
        },
      ),
      GoRoute(
        path: collectionBook,
        pageBuilder: (context, state) {
          final collectionId = state.extra as int?;
          if (collectionId == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少书籍收藏夹ID参数"));
          }
          return MaterialPage(
            child: CollectionBookView(collectionId: collectionId),
          );
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
          if (url == null || url.isEmpty) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少URL参数"));
          }
          return MaterialPage(child: ParseWebView(url: url));
        },
      ),
      GoRoute(
        path: parseImageFolder,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is String) {
            return MaterialPage(child: ParseImageFolderView(folderPath: extra));
          }
          if (extra is List<String>) {
            return MaterialPage(child: ParseImageFolderView(imagePaths: extra));
          }
          if (extra is List) {
            final paths = extra.whereType<String>().toList();
            if (paths.isNotEmpty) {
              return MaterialPage(
                child: ParseImageFolderView(imagePaths: paths),
              );
            }
          }
          return MaterialPage(child: ErrorRoutePage(message: "缺少图片路径参数"));
        },
      ),
      GoRoute(
        path: parseBatchImageFolder,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is String) {
            return MaterialPage(
              child: ParseBatchImageFolderView(parentDirPath: extra),
            );
          }
          if (extra is List<String>) {
            return MaterialPage(
              child: ParseBatchImageFolderView(imagePaths: extra),
            );
          }
          if (extra is List) {
            final paths = extra.whereType<String>().toList();
            if (paths.isNotEmpty) {
              return MaterialPage(
                child: ParseBatchImageFolderView(imagePaths: paths),
              );
            }
          }
          return MaterialPage(child: ErrorRoutePage(message: "缺少图片路径参数"));
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
          final extra = state.extra;
          if (extra is String) {
            return MaterialPage(
              child: ParseBatchArchiveView(archiveDirPath: extra),
            );
          }
          if (extra is List<String>) {
            return MaterialPage(
              child: ParseBatchArchiveView(archivePaths: extra),
            );
          }
          if (extra is List) {
            final paths = extra.whereType<String>().toList();
            if (paths.isNotEmpty) {
              return MaterialPage(
                child: ParseBatchArchiveView(archivePaths: paths),
              );
            }
          }
          if (extra == null) {
            return MaterialPage(child: ErrorRoutePage(message: "缺少路径参数"));
          }
          return MaterialPage(child: ErrorRoutePage(message: "批量压缩包参数格式错误"));
        },
      ),
      GoRoute(
        path: parsePdf,
        pageBuilder: (context, state) {
          final path = state.extra as String?;
          if (path == null) {
            return MaterialPage(
              child: ErrorRoutePage(message: "缺少 PDF 文件路径参数"),
            );
          }
          return MaterialPage(child: ParsePdfView(pdfPath: path));
        },
      ),
      GoRoute(
        path: parseBatchPdf,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is String) {
            return MaterialPage(child: ParseBatchPdfView(pdfDirPath: extra));
          }
          if (extra is List<String>) {
            return MaterialPage(child: ParseBatchPdfView(pdfPaths: extra));
          }
          if (extra is List) {
            final paths = extra.whereType<String>().toList();
            if (paths.isNotEmpty) {
              return MaterialPage(child: ParseBatchPdfView(pdfPaths: paths));
            }
          }
          return MaterialPage(child: ErrorRoutePage(message: "缺少 PDF 路径参数"));
        },
      ),
      GoRoute(
        path: syncServer,
        pageBuilder: (context, state) {
          return MaterialPage(child: SyncServerView());
        },
      ),
      GoRoute(
        path: syncBooks,
        pageBuilder: (context, state) {
          return MaterialPage(child: SyncBooksView());
        },
      ),
      GoRoute(
        path: syncHistory,
        pageBuilder: (context, state) {
          return MaterialPage(child: SyncHistoryView());
        },
      ),
      GoRoute(
        path: syncHistoryDetail,
        pageBuilder: (context, state) {
          final item = state.extra;
          if (item is! SyncHistoryItem) {
            return MaterialPage(child: ErrorRoutePage(message: '缺少归档参数'));
          }
          return MaterialPage(child: SyncHistoryDetailView(item: item));
        },
      ),
      GoRoute(
        path: syncLogList,
        pageBuilder: (context, state) {
          return MaterialPage(child: SyncLogListView());
        },
      ),
      GoRoute(
        path: syncLogDetail,
        pageBuilder: (context, state) {
          final logId = state.extra;
          if (logId is! int) {
            return MaterialPage(child: ErrorRoutePage(message: '缺少记录ID参数'));
          }
          return MaterialPage(child: SyncLogDetailView(logId: logId));
        },
      ),
      GoRoute(
        path: syncDownload,
        pageBuilder: (context, state) {
          return MaterialPage(child: SyncDownloadView());
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
