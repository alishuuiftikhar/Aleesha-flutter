import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library_system_v4.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        category TEXT NOT NULL,
        is_available INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        roll_no TEXT NOT NULL,
        department TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE issued_books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id INTEGER,
        student_id INTEGER,
        issue_date TEXT NOT NULL,
        return_date TEXT
      )
    ''');
  }

  // --- BOOK METHODS ---
  Future<int> insertBook(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('books', row);
  }

  Future<List<Map<String, dynamic>>> fetchBooks({String? query}) async {
    final db = await instance.database;
    if (query != null && query.isNotEmpty) {
      return await db.query(
        'books',
        where: 'title LIKE ? OR author LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
    }
    return await db.query('books', orderBy: 'id DESC');
  }

  Future<int> updateBook(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update('books', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // --- STUDENT METHODS ---
  Future<int> insertStudent(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('students', row);
  }

  Future<List<Map<String, dynamic>>> fetchStudents() async {
    final db = await instance.database;
    return await db.query('students', orderBy: 'id DESC');
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // --- ISSUE & RETURN METHODS ---
  Future<void> issueBookWithStudent({
    required int bookId,
    required String studentName,
    required String rollNo,
  }) async {
    final db = await instance.database;

    List<Map<String, dynamic>> existingStudent = await db.query(
      'students',
      where: 'roll_no = ?',
      whereArgs: [rollNo],
    );

    int studentId;
    if (existingStudent.isNotEmpty) {
      studentId = existingStudent.first['id'];
    } else {
      studentId = await db.insert('students', {
        'name': studentName,
        'roll_no': rollNo,
        'department': 'General',
      });
    }

    await db.update('books', {'is_available': 0}, where: 'id = ?', whereArgs: [bookId]);

    await db.insert('issued_books', {
      'book_id': bookId,
      'student_id': studentId,
      'issue_date': DateTime.now().toString().split(' ')[0],
      'return_date': null,
    });
  }

  Future<void> returnBook(int issueId, int bookId) async {
    final db = await instance.database;
    await db.update('books', {'is_available': 1}, where: 'id = ?', whereArgs: [bookId]);
    await db.delete('issued_books', where: 'id = ?', whereArgs: [issueId]);
  }

  Future<List<Map<String, dynamic>>> fetchIssuedBooks() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT issued_books.id as issue_id, 
             books.id as book_id, 
             books.title as title, 
             students.name as name, 
             students.roll_no as roll_no, 
             issued_books.issue_date as issue_date 
      FROM issued_books
      JOIN books ON issued_books.book_id = books.id
      JOIN students ON issued_books.student_id = students.id
    ''');
  }
}