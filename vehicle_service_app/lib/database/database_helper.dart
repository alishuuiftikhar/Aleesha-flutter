import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../models/part.dart';
import '../models/reminder.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vehicle_service.db');
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
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const nullableTextType = 'TEXT';
    const nullableIntType = 'INTEGER';

    await db.execute('''
CREATE TABLE vehicles (
  id $idType,
  name $textType,
  model $textType,
  make $textType,
  year $intType,
  licensePlate $textType,
  currentMileage $intType,
  imageUrl $nullableTextType
)
''');

    await db.execute('''
CREATE TABLE service_records (
  id $idType,
  vehicleId $intType,
  serviceType $textType,
  date $textType,
  mileage $intType,
  cost $realType,
  description $textType,
  nextServiceDate $nullableTextType,
  nextServiceMileage $nullableIntType,
  FOREIGN KEY (vehicleId) REFERENCES vehicles (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE parts (
  id $idType,
  serviceRecordId $intType,
  name $textType,
  cost $realType,
  FOREIGN KEY (serviceRecordId) REFERENCES service_records (id) ON DELETE CASCADE
)
''');

    await db.execute('''
CREATE TABLE reminders (
  id $idType,
  vehicleId $intType,
  title $textType,
  dueDate $textType,
  dueMileage $nullableIntType,
  isCompleted $boolType,
  FOREIGN KEY (vehicleId) REFERENCES vehicles (id) ON DELETE CASCADE
)
''');
  }

  // Vehicles
  Future<int> createVehicle(Vehicle vehicle) async {
    final db = await instance.database;
    return await db.insert('vehicles', vehicle.toMap());
  }

  Future<Vehicle?> readVehicle(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'vehicles',
      columns: ['id', 'name', 'model', 'make', 'year', 'licensePlate', 'currentMileage', 'imageUrl'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Vehicle.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Vehicle>> readAllVehicles() async {
    final db = await instance.database;
    final result = await db.query('vehicles');
    return result.map((json) => Vehicle.fromMap(json)).toList();
  }

  Future<int> updateVehicle(Vehicle vehicle) async {
    final db = await instance.database;
    return db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<int> deleteVehicle(int id) async {
    final db = await instance.database;
    return await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Service Records
  Future<int> createServiceRecord(ServiceRecord record) async {
    final db = await instance.database;
    return await db.insert('service_records', record.toMap());
  }

  Future<List<ServiceRecord>> readServiceRecords(int vehicleId) async {
    final db = await instance.database;
    final result = await db.query(
      'service_records',
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
    );
    return result.map((json) => ServiceRecord.fromMap(json)).toList();
  }

  Future<int> updateServiceRecord(ServiceRecord record) async {
    final db = await instance.database;
    return db.update(
      'service_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteServiceRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'service_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Parts
  Future<int> createPart(Part part) async {
    final db = await instance.database;
    return await db.insert('parts', part.toMap());
  }

  Future<List<Part>> readParts(int serviceRecordId) async {
    final db = await instance.database;
    final result = await db.query(
      'parts',
      where: 'serviceRecordId = ?',
      whereArgs: [serviceRecordId],
    );
    return result.map((json) => Part.fromMap(json)).toList();
  }

  Future<int> deletePartsForService(int serviceRecordId) async {
    final db = await instance.database;
    return await db.delete(
      'parts',
      where: 'serviceRecordId = ?',
      whereArgs: [serviceRecordId],
    );
  }

  // Reminders
  Future<int> createReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> readReminders(int vehicleId) async {
    final db = await instance.database;
    final result = await db.query(
      'reminders',
      where: 'vehicleId = ? AND isCompleted = 0',
      orderBy: 'dueDate ASC',
    );
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
