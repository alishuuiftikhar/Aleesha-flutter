import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/astronomy_object.dart';
import '../models/observation.dart';
import '../models/quiz.dart';
import '../models/checklist_item.dart';
import '../data/initial_data.dart';

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
    String path = join(await getDatabasesPath(), 'astronomy_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE astronomy_objects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        category TEXT,
        image TEXT,
        description TEXT,
        distance TEXT,
        size TEXT,
        discoveryInfo TEXT,
        facts TEXT,
        relatedObjects TEXT,
        isFavorite INTEGER,
        lastViewed TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE observations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        objectName TEXT,
        date TEXT,
        time TEXT,
        location TEXT,
        equipment TEXT,
        notes TEXT,
        rating REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        options TEXT,
        correctIndex INTEGER,
        difficulty TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        score INTEGER,
        totalQuestions INTEGER,
        difficulty TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isCompleted INTEGER
      )
    ''');

    // Seed initial data
    for (var obj in InitialData.objects) {
      await db.insert('astronomy_objects', obj.toMap());
    }
    for (var q in InitialData.questions) {
      await db.insert('quiz_questions', q.toMap());
    }
    for (var item in InitialData.checklist) {
      await db.insert('checklist_items', item.toMap());
    }
  }

  // Generic CRUD helpers could be added here or in specific services
}
