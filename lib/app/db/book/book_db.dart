import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wo_nas/app/model/dto/book_dto.dart';

class BookDB {
  final String _booksTableName = "book";
  final String _booksIdColumnName = "id";
  final String _booksTitleColumnName = "title";
  final String _booksPathColumnName = "path";
  final String _booksCreateTimeColumnName = "create_time";
  final String _booksUpdateTimeColumnName = "update_time";

  BookDB._constructor();

  static final BookDB instance = BookDB._constructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database?> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "TeleBook_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
            CREATE TABLE $_booksTableName (
              $_booksIdColumnName INTEGER PRIMARY KEY,
              $_booksTitleColumnName TEXT NOT NULL,
              $_booksPathColumnName TEXT NOT NULL,
              $_booksCreateTimeColumnName TEXT NOT NULL,
              $_booksUpdateTimeColumnName TEXT NOT NULL
            )
            ''');
      },
    );
    return database;
  }

  Future<int> insertBook(BookDTO book) async {
    final db = await database;
    final id = await db.insert(_booksTableName, {
      _booksTitleColumnName: book.title,
      _booksPathColumnName: book.path,
      _booksCreateTimeColumnName: DateTime.now().toString(),
      _booksUpdateTimeColumnName: DateTime.now().toString()
    });
    return id;
  }

  Future<List<BookDTO>> queryBooks() async {
    final db = await database;
    final data = await db.query(_booksTableName);
    List<BookDTO> bookDTOs = data
        .map((item) => BookDTO(
            id: item[_booksIdColumnName] as int,
            title: item[_booksTitleColumnName] as String,
            path: item[_booksPathColumnName] as String,
            createTime: item[_booksCreateTimeColumnName] as String,
            updateTIme: item[_booksUpdateTimeColumnName] as String))
        .toList();
    return bookDTOs;
  }

  deleteBook(int id) async {
    final db = await database;
    await db.delete(_booksTableName,
        where: "$_booksIdColumnName = ?", whereArgs: [id]);
  }
}
