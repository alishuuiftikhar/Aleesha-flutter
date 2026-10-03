import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/device.dart';
import '../models/technician.dart';
import '../models/repair_order.dart';
import '../models/part.dart';
import '../models/repair_part.dart';
import '../models/payment.dart';
import '../models/repair_note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('electronics_repair.db');
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const floatType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE customers (
  id $idType,
  name $textType,
  phone $textType,
  email $textType,
  address $textType
)
''');

    await db.execute('''
CREATE TABLE devices (
  id $idType,
  customer_id $integerType,
  type $textType,
  model $textType,
  serial_number $textType,
  FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE technicians (
  id $idType,
  name $textType,
  specialization $textType
)
''');

    await db.execute('''
CREATE TABLE repair_orders (
  id $idType,
  device_id $integerType,
  technician_id $integerType,
  problem_description $textType,
  status $textType,
  estimated_cost $floatType,
  final_cost $floatType,
  created_at $textType,
  updated_at $textType,
  FOREIGN KEY (device_id) REFERENCES devices (id) ON DELETE CASCADE,
  FOREIGN KEY (technician_id) REFERENCES technicians (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE parts (
  id $idType,
  name $textType,
  price $floatType,
  stock_quantity $integerType
)
''');

    await db.execute('''
CREATE TABLE repair_parts (
  id $idType,
  repair_order_id $integerType,
  part_id $integerType,
  quantity $integerType,
  price_at_time $floatType,
  FOREIGN KEY (repair_order_id) REFERENCES repair_orders (id) ON DELETE CASCADE,
  FOREIGN KEY (part_id) REFERENCES parts (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE payments (
  id $idType,
  repair_order_id $integerType,
  amount $floatType,
  payment_date $textType,
  payment_method $textType,
  FOREIGN KEY (repair_order_id) REFERENCES repair_orders (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE repair_notes (
  id $idType,
  repair_order_id $integerType,
  note $textType,
  created_at $textType,
  FOREIGN KEY (repair_order_id) REFERENCES repair_orders (id) ON DELETE CASCADE
)
''');

    // Insert some initial data
    await db.insert('technicians', {'name': 'John Doe', 'specialization': 'Mobile Phones'});
    await db.insert('technicians', {'name': 'Jane Smith', 'specialization': 'Laptops'});
  }

  // Generic CRUD
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Specific queries
  Future<List<Map<String, dynamic>>> getRepairOrdersWithDetails() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT ro.*, d.model as device_model, d.type as device_type, c.name as customer_name, t.name as technician_name
      FROM repair_orders ro
      JOIN devices d ON ro.device_id = d.id
      JOIN customers c ON d.customer_id = c.id
      JOIN technicians t ON ro.technician_id = t.id
      ORDER BY ro.updated_at DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getCustomerHistory(int customerId) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT ro.*, d.model, d.type
      FROM repair_orders ro
      JOIN devices d ON ro.device_id = d.id
      WHERE d.customer_id = ?
      ORDER BY ro.created_at DESC
    ''', [customerId]);
  }

  Future<double> getTotalRevenue() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM payments');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
  
  Future<int> close() async {
    final db = await instance.database;
    await db.close();
    return 1;
  }
}
