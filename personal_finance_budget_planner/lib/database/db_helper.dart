import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/savings_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDB();
      return _database!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Database> _initDB() async {
    try {
      String path = join(await getDatabasesPath(), 'finance_planner.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      // Return a dummy database or throw to be caught by provider
      throw Exception("SQLite not supported on this platform: $e");
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        limit_amount REAL NOT NULL,
        month TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE savings_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        target_amount REAL NOT NULL,
        current_amount REAL DEFAULT 0.0,
        deadline TEXT
      )
    ''');

    // Initial Categories
    List<Category> initialCategories = [
      Category(name: 'Food', icon: 'fastfood', color: 0xFFE9C46A),
      Category(name: 'Transport', icon: 'directions_car', color: 0xFF527B8A),
      Category(name: 'Shopping', icon: 'shopping_bag', color: 0xFF355070),
      Category(name: 'Entertainment', icon: 'movie', color: 0xFFE76F51),
      Category(name: 'Health', icon: 'medical_services', color: 0xFF2A9D8F),
      Category(name: 'Education', icon: 'school', color: 0xFF264653),
      Category(name: 'Salary', icon: 'payments', color: 0xFF8AB17D),
      Category(name: 'Investment', icon: 'trending_up', color: 0xFFE9C46A),
    ];

    for (var cat in initialCategories) {
      await db.insert('categories', cat.toMap());
    }
  }

  // Generic CRUD
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Specialized Queries
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT t.*, c.name as categoryName, c.icon as categoryIcon, c.color as categoryColor
      FROM transactions t
      JOIN categories c ON t.category_id = c.id
      ORDER BY t.date DESC
    ''');
  }
  
  Future<List<Map<String, dynamic>>> getBudgetsWithCategory(String month) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT b.*, c.name as categoryName, c.icon as categoryIcon, c.color as categoryColor,
      (SELECT SUM(amount) FROM transactions WHERE category_id = b.category_id AND type = 'expense' AND strftime('%Y-%m', date) = ?) as spent
      FROM budgets b
      JOIN categories c ON b.category_id = c.id
      WHERE b.month = ?
    ''', [month, month]);
  }
}
