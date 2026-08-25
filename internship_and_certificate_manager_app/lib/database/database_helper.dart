import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
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
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const intTypeNullable = 'INTEGER';

    // Students table
    await db.execute('''
      CREATE TABLE students (
        id $idType,
        name $textType,
        university $textType,
        degree $textType,
        semester $textType,
        skills $textTypeNullable,
        email $textTypeNullable,
        phone $textTypeNullable,
        profile_image $textTypeNullable
      )
    ''');

    // Companies table
    await db.execute('''
      CREATE TABLE companies (
        id $idType,
        name $textType,
        location $textTypeNullable,
        website $textTypeNullable
      )
    ''');

    // Supervisors table
    await db.execute('''
      CREATE TABLE supervisors (
        id $idType,
        name $textType,
        contact $textTypeNullable,
        company_id $intType,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
      )
    ''');

    // Internships table
    await db.execute('''
      CREATE TABLE internships (
        id $idType,
        company_id $intType,
        supervisor_id $intTypeNullable,
        position $textType,
        department $textType,
        start_date $textType,
        end_date $textType,
        duration $textType,
        status $textType,
        description $textTypeNullable,
        FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE,
        FOREIGN KEY (supervisor_id) REFERENCES supervisors (id) ON DELETE SET NULL
      )
    ''');

    // Certificates table
    await db.execute('''
      CREATE TABLE certificates (
        id $idType,
        title $textType,
        organization $textType,
        issue_date $textType,
        certificate_id $textTypeNullable,
        category $textType,
        description $textTypeNullable,
        image_path $textTypeNullable,
        status $textType,
        is_favorite $intType DEFAULT 0
      )
    ''');

    // Internship Notes table
    await db.execute('''
      CREATE TABLE internship_notes (
        id $idType,
        internship_id $intType,
        content $textType,
        created_at $textType,
        FOREIGN KEY (internship_id) REFERENCES internships (id) ON DELETE CASCADE
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id $idType,
        item_type $textType, -- 'internship' or 'certificate'
        item_id $intType
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
