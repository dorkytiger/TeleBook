import 'package:wo_nas/app/db/book_db.dart';
import 'package:wo_nas/app/db/book_picture_db.dart';
import 'package:wo_nas/app/model/dto/book_dto.dart';
import 'package:wo_nas/app/model/dto/book_picture_dto.dart';
import 'package:wo_nas/app/model/vo/book_vo.dart';

class BookService {
  static final BookService _instance = BookService._internal();

  factory BookService() {
    return _instance;
  }

  BookService._internal();

  final BookDB _bookDB = BookDB.instance;
  final BookPictureDB _bookPictureDB = BookPictureDB.instance;

  Future<List<BookVO>> getBooks() async {
    try {
      List<BookDTO> bookDTOs = await _bookDB.queryBooks();
      if (bookDTOs.isNotEmpty) {
        var bookVOList = <BookVO>[];
        for (BookDTO bookDTO in bookDTOs) {
          final bookId = bookDTO.id!;
          var bookPictureDTOs = await _bookPictureDB.queryPictures(bookId);
          var bookPictureList =
              bookPictureDTOs.map((item) => item.path).toList();
          final bookVO = BookVO(
              id: bookDTO.id!,
              path: bookDTO.path,
              preview: bookPictureList.first,
              title: bookDTO.title,
              pictures: bookPictureList);
          bookVOList.add(bookVO);
        }
        return bookVOList;
      }
      return [];
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<int?> addBook(BookDTO bookDTO) async {
    try {
      final bookId = await _bookDB.insertBook(bookDTO);
      return bookId;
    } catch (e) {
      print(e);
    }
    return null;
  }

  addBookPicture(BookPictureDto bookPictureDTo) async {
    try {
      await _bookPictureDB.insertPicture(bookPictureDTo);
    } catch (e) {
      print(e);
    }
  }
}
