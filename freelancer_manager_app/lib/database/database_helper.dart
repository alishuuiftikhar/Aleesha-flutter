import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('freelancer.db');
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
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const textNullableType = 'TEXT';

    await db.execute('''
      CREATE TABLE clients (
        id $idType,
        name $textType,
        email $textType,
        phone $textType,
        company $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id $idType,
        name $textType,
        description $textType,
        client_id $integerType,
        deadline $textType,
        budget $realType,
        status $textType,
        FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        project_id $integerType,
        title $textType,
        description $textType,
        is_completed $boolType,
        priority $textType,
        deadline $textNullableType,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE time_entries (
        id $idType,
        project_id $integerType,
        start_time $textType,
        end_time $textNullableType,
        description $textType,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id $idType,
        project_id $integerType,
        category $textType,
        amount $realType,
        date $textType,
        description $textType,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        project_id $integerType,
        title $textType,
        content $textType,
        created_at $textType,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');
  }

  // Generic CRUD operations
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
  Future<List<Project>> getProjects() async {
    final db = await instance.database;
    final result = await db.query('projects');
    return result.map((json) => Project.fromMap(json)).toList();
  }

  Future<List<Client>> getClients() async {
    final db = await instance.database;
    final result = await db.query('clients');
    return result.map((json) => Client.fromMap(json)).toList();
  }

  Future<List<Task>> getTasks(int projectId) async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'project_id = ?', whereArgs: [projectId]);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<List<Expense>> getExpenses(int projectId) async {
    final db = await instance.database;
    final result = await db.query('expenses', where: 'project_id = ?', whereArgs: [projectId]);
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<List<Note>> getNotes(int projectId) async {
    final db = await instance.database;
    final result = await db.query('notes', where: 'project_id = ?', whereArgs: [projectId]);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<TimeEntry>> getTimeEntries(int projectId) async {
    final db = await instance.database;
    final result = await db.query('time_entries', where: 'project_id = ?', whereArgs: [projectId]);
    return result.map((json) => TimeEntry.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
