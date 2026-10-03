import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'online_exam.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT
      )
    ''');

    // Exams table
    await db.execute('''
      CREATE TABLE exams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        category TEXT,
        duration_minutes INTEGER,
        total_marks INTEGER,
        is_published INTEGER,
        creator_id INTEGER,
        FOREIGN KEY (creator_id) REFERENCES users (id)
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER,
        question_text TEXT,
        marks INTEGER,
        FOREIGN KEY (exam_id) REFERENCES exams (id) ON DELETE CASCADE
      )
    ''');

    // Options table
    await db.execute('''
      CREATE TABLE options(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER,
        option_text TEXT,
        is_correct INTEGER,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');

    // Exam Attempts table
    await db.execute('''
      CREATE TABLE exam_attempts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        exam_id INTEGER,
        start_time TEXT,
        end_time TEXT,
        score INTEGER,
        status INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (exam_id) REFERENCES exams (id)
      )
    ''');

    // User Answers table
    await db.execute('''
      CREATE TABLE user_answers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        attempt_id INTEGER,
        question_id INTEGER,
        selected_option_id INTEGER,
        FOREIGN KEY (attempt_id) REFERENCES exam_attempts (id) ON DELETE CASCADE,
        FOREIGN KEY (question_id) REFERENCES questions (id),
        FOREIGN KEY (selected_option_id) REFERENCES options (id)
      )
    ''');

    // Insert dummy admin
    await db.insert('users', {
      'name': 'Admin User',
      'email': 'admin@exam.com',
      'password': 'admin',
      'role': 'admin'
    });
  }

  // --- User Operations ---
  Future<int> registerUser(AppUser user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<AppUser?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return AppUser.fromMap(maps.first);
    }
    return null;
  }

  // --- Exam Operations ---
  Future<int> insertExam(Exam exam) async {
    final db = await database;
    return await db.insert('exams', exam.toMap());
  }

  Future<List<Exam>> getExams({bool onlyPublished = false}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = onlyPublished
        ? await db.query('exams', where: 'is_published = ?', whereArgs: [1])
        : await db.query('exams');
    return List.generate(maps.length, (i) => Exam.fromMap(maps[i]));
  }

  Future<int> updateExam(Exam exam) async {
    final db = await database;
    return await db.update('exams', exam.toMap(), where: 'id = ?', whereArgs: [exam.id]);
  }

  Future<int> deleteExam(int id) async {
    final db = await database;
    return await db.delete('exams', where: 'id = ?', whereArgs: [id]);
  }

  // --- Question & Option Operations ---
  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('questions', question.toMap());
  }

  Future<int> insertOption(QuestionOption option) async {
    final db = await database;
    return await db.insert('options', option.toMap());
  }

  Future<List<Question>> getQuestionsForExam(int examId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions', where: 'exam_id = ?', whereArgs: [examId]);
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<List<QuestionOption>> getOptionsForQuestion(int questionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('options', where: 'question_id = ?', whereArgs: [questionId]);
    return List.generate(maps.length, (i) => QuestionOption.fromMap(maps[i]));
  }

  // --- Attempt & Result Operations ---
  Future<int> startAttempt(ExamAttempt attempt) async {
    final db = await database;
    return await db.insert('exam_attempts', attempt.toMap());
  }

  Future<void> submitAnswer(UserAnswer answer) async {
    final db = await database;
    await db.insert('user_answers', answer.toMap());
  }

  Future<void> completeAttempt(int attemptId, int score, String endTime) async {
    final db = await database;
    await db.update(
      'exam_attempts',
      {'score': score, 'status': 1, 'end_time': endTime},
      where: 'id = ?',
      whereArgs: [attemptId],
    );
  }

  Future<List<ExamAttempt>> getUserAttempts(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exam_attempts', where: 'user_id = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) => ExamAttempt.fromMap(maps[i]));
  }
}
