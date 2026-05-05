import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tele_book/feature/book/service/book_service.dart';

List<SingleChildWidget> createServiceDI() {
  return [Provider(create: (context) => BookService(context.read()))];
}
