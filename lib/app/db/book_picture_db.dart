import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wo_nas/app/model/dto/book_picture_dto.dart';

class BookPictureDB {
  final String _bookPictureTableName = "book_picture";
  final String _bookPictureIdColumnName = "id";
  final String _bookPictureBookIdColumnName = "book_id";
  final String _bookPicturePathColumnName = "path";
  final String _bookPictureNumberColumnName = "number";

  BookPictureDB._constructor();

  static final BookPictureDB instance = BookPictureDB._constructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    var result = await _db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$_bookPictureTableName'");
    if (result.isEmpty) {
      await _onCreate(_db!, 1);
    }
    return _db!;
  }

  _onCreate(db, version) async {
    await db.execute('''
        CREATE TABLE $_bookPictureTableName (
          $_bookPictureIdColumnName INTEGER PRIMARY KEY,
          $_bookPictureBookIdColumnName INTEGER NOT NULL,
          $_bookPicturePathColumnName TEXT NOT NULL,
          $_bookPictureNumberColumnName INTEGER NOT NULL
        )
      ''');
  }

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "TeleBook_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  Future<int> insertPicture(BookPictureDto bookPictureDto) async {
    final db = await database;
    final id = await db.insert(_bookPictureTableName, {
      _bookPictureBookIdColumnName: bookPictureDto.bookId,
      _bookPicturePathColumnName: bookPictureDto.path,
      _bookPictureNumberColumnName: bookPictureDto.number
    });
    return id;
  }

  Future<List<BookPictureDto>> queryPictures(int bookId) async {
    final db = await database;
    final data = await db.query(_bookPictureTableName,
        where: "$_bookPictureBookIdColumnName = ?", whereArgs: [bookId]);
    return data
        .map((item) => BookPictureDto(
            id: item[_bookPictureIdColumnName] as int,
            bookId: item[_bookPictureBookIdColumnName] as int,
            path: item[_bookPicturePathColumnName] as String,
            number: item[_bookPictureNumberColumnName] as int))
        .toList();
  }
}
