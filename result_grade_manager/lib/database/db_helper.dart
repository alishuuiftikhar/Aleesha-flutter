import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../models/mark.dart';
import '../models/semester.dart';

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
    String path = join(await getDatabasesPath(), 'student_result_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        roll_number TEXT,
        grade TEXT,
        profile_image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        code TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE semesters(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE marks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER,
        subject_id INTEGER,
        semester_id INTEGER,
        marks_obtained REAL,
        max_marks REAL,
        FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE,
        FOREIGN KEY (semester_id) REFERENCES semesters (id) ON DELETE CASCADE
      )
    ''');
  }

  // Student CRUD
  Future<int> insertStudent(Student student) async {
    Database db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) => Student.fromMap(maps[i]));
  }

  Future<int> updateStudent(Student student) async {
    Database db = await database;
    return await db.update('students', student.toMap(), where: 'id = ?', whereArgs: [student.id]);
  }

  Future<int> deleteStudent(int id) async {
    Database db = await database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // Subject CRUD
  Future<int> insertSubject(Subject subject) async {
    Database db = await database;
    return await db.insert('subjects', subject.toMap());
  }

  Future<List<Subject>> getSubjects() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('subjects');
    return List.generate(maps.length, (i) => Subject.fromMap(maps[i]));
  }

  Future<int> updateSubject(Subject subject) async {
    Database db = await database;
    return await db.update('subjects', subject.toMap(), where: 'id = ?', whereArgs: [subject.id]);
  }

  Future<int> deleteSubject(int id) async {
    Database db = await database;
    return await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  // Semester CRUD
  Future<int> insertSemester(Semester semester) async {
    Database db = await database;
    return await db.insert('semesters', semester.toMap());
  }

  Future<List<Semester>> getSemesters() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('semesters');
    return List.generate(maps.length, (i) => Semester.fromMap(maps[i]));
  }

  // Marks CRUD
  Future<int> insertMark(Mark mark) async {
    Database db = await database;
    return await db.insert('marks', mark.toMap());
  }

  Future<List<Mark>> getMarksForStudent(int studentId, int semesterId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'marks',
      where: 'student_id = ? AND semester_id = ?',
      whereArgs: [studentId, semesterId],
    );
    return List.generate(maps.length, (i) => Mark.fromMap(maps[i]));
  }

  Future<int> updateMark(Mark mark) async {
    Database db = await database;
    return await db.update('marks', mark.toMap(), where: 'id = ?', whereArgs: [mark.id]);
  }

  // Aggregated Results
  Future<List<Map<String, dynamic>>> getStudentSemesterSummary(int studentId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT 
        s.name as semester_name,
        s.id as semester_id,
        SUM(m.marks_obtained) as total_obtained,
        SUM(m.max_marks) as total_max,
        COUNT(m.id) as subjects_count
      FROM semesters s
      JOIN marks m ON s.id = m.semester_id
      WHERE m.student_id = ?
      GROUP BY s.id
    ''', [studentId]);
  }

  Future<List<Map<String, dynamic>>> getDashboardStats() async {
    Database db = await database;
    var studentsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM students')) ?? 0;
    var subjectsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM subjects')) ?? 0;
    
    return [{'students': studentsCount, 'subjects': subjectsCount}];
  }
}
