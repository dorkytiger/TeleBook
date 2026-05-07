import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/service/book_service.dart';
import 'package:tele_book/feature/download/service/download_service.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';
import 'package:tele_book/feature/parse/service/parse_web_service.dart';

List<SingleChildWidget> createServiceDI() {
  return [
    Provider(create: (context) => BookService(context.read())),
    Provider(create: (context) => ParseWebService()),
    Provider(create: (context) => ParseArchiveService()),
    Provider(
      create: (context) => DownloadService(context.read(), context.read()),
    ),
  ];
}
