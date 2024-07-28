import 'package:get/get.dart';
import 'package:wo_nas/app/db/book/book_db.dart';
import 'package:wo_nas/app/db/book/book_picture_db.dart';
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
              pictures: bookPictureList,
              createTime: bookDTO.createTime!);
          bookVOList.add(bookVO);
        }
        return bookVOList;
      }
      return [];
    } catch (e) {
      Get.snackbar('获取书籍错误', e.toString(), snackPosition: SnackPosition.TOP);
    }
    return [];
  }

  Future<int?> addBook(BookDTO bookDTO) async {
    try {
      final bookId = await _bookDB.insertBook(bookDTO);
      return bookId;
    } catch (e) {
      Get.snackbar('添加书籍错误', e.toString(), snackPosition: SnackPosition.TOP);
    }
    return null;
  }

  addBookPicture(BookPictureDto bookPictureDTo) async {
    try {
      await _bookPictureDB.insertPicture(bookPictureDTo);
    } catch (e) {
      Get.snackbar('添加书籍图片错误', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  deleteBooks(Set<int> bookIds) async {
    try {
      for (var bookId in bookIds) {
        await _bookDB.deleteBook(bookId);
        await _bookPictureDB.deletePictures(bookId);
      }
    } catch (e) {
      Get.snackbar('删除书籍错误', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }
}
