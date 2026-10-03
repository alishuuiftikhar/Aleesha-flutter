import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'parking_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parking_lots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT,
        total_spaces INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE parking_spaces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lot_id INTEGER,
        space_number TEXT NOT NULL,
        is_occupied INTEGER DEFAULT 0,
        vehicle_type TEXT,
        FOREIGN KEY (lot_id) REFERENCES parking_lots (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        plate_number TEXT NOT NULL UNIQUE,
        vehicle_type TEXT NOT NULL,
        model TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE parking_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER,
        space_id INTEGER,
        check_in_time TEXT NOT NULL,
        check_out_time TEXT,
        total_fee REAL DEFAULT 0.0,
        status TEXT DEFAULT 'active',
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id),
        FOREIGN KEY (space_id) REFERENCES parking_spaces (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        amount REAL NOT NULL,
        payment_date TEXT NOT NULL,
        payment_method TEXT,
        FOREIGN KEY (session_id) REFERENCES parking_sessions (id)
      )
    ''');

    // Seed some initial data
    await db.insert('parking_lots', {'name': 'Main Street Plaza', 'location': 'Downtown', 'total_spaces': 20});
    for (int i = 1; i <= 20; i++) {
      await db.insert('parking_spaces', {
        'lot_id': 1,
        'space_number': 'A$i',
        'is_occupied': 0,
        'vehicle_type': i <= 10 ? 'Car' : 'Bike'
      });
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

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
  
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }
}
