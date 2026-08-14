import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'booknest_pro.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        description TEXT,
        cover_url TEXT,
        category TEXT,
        type TEXT,
        pages INTEGER,
        language TEXT,
        publication_year INTEGER,
        rating REAL,
        total_duration TEXT,
        content_path TEXT,
        isbn TEXT,
        audio_url TEXT,
        narrator TEXT,
        source TEXT,
        open_library_id TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        current_page INTEGER,
        total_pages INTEGER,
        progress REAL,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE recently_viewed (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        page_number INTEGER,
        note TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE audio_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        position_seconds INTEGER,
        duration_seconds INTEGER,
        progress REAL,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');
  }

  Future<void> insertOrUpdateBook(Book book) async {
    final db = await database;
    
    // Use title and author as unique identifier for this project
    final existing = await db.query(
      'books', 
      where: 'title = ? AND author = ?', 
      whereArgs: [book.title, book.author]
    );

    if (existing.isEmpty) {
      await db.insert('books', book.toMap());
    } else {
      await db.update(
        'books', 
        book.toMap(), 
        where: 'id = ?', 
        whereArgs: [existing.first['id']]
      );
    }
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books', orderBy: 'title ASC');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<List<Book>> getBooksByType(BookType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'type = ?',
      whereArgs: [type.name],
      orderBy: 'title ASC'
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'title ASC'
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> toggleFavorite(int bookId) async {
    final db = await database;
    final favorites = await db.query('favorites', where: 'book_id = ?', whereArgs: [bookId]);
    if (favorites.isEmpty) {
      await db.insert('favorites', {'book_id': bookId});
    } else {
      await db.delete('favorites', where: 'book_id = ?', whereArgs: [bookId]);
    }
  }

  Future<bool> isFavorite(int bookId) async {
    final db = await database;
    final favorites = await db.query('favorites', where: 'book_id = ?', whereArgs: [bookId]);
    return favorites.isNotEmpty;
  }
  
  Future<List<Book>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT books.* FROM books
      INNER JOIN favorites ON books.id = favorites.book_id
    ''');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  // Progress & Bookmarks
  Future<void> updateReadingProgress(int bookId, int currentPage, int totalPages) async {
    final db = await database;
    double progress = (currentPage / totalPages) * 100;
    await db.insert(
      'reading_progress',
      {
        'book_id': bookId,
        'current_page': currentPage,
        'total_pages': totalPages,
        'progress': progress,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getReadingProgress(int bookId) async {
    final db = await database;
    final results = await db.query(
      'reading_progress',
      where: 'book_id = ?',
      whereArgs: [bookId],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> addBookmark(int bookId, int pageNumber, String note) async {
    final db = await database;
    // Note: If you want to keep the bookmarks table, make sure it's created in _onCreate
    // For now I'll just insert into the table I defined in _onCreate
    await db.insert('bookmarks', {
      'book_id': bookId,
      'page_number': pageNumber,
      'note': note,
    });
  }

  // Audio Progress
  Future<void> updateAudioProgress(int bookId, int positionSeconds, int durationSeconds) async {
    final db = await database;
    double progress = durationSeconds > 0 ? (positionSeconds / durationSeconds) * 100 : 0;
    await db.insert(
      'audio_progress',
      {
        'book_id': bookId,
        'position_seconds': positionSeconds,
        'duration_seconds': durationSeconds,
        'progress': progress,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getAudioProgress(int bookId) async {
    final db = await database;
    final results = await db.query(
      'audio_progress',
      where: 'book_id = ?',
      whereArgs: [bookId],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }
}
