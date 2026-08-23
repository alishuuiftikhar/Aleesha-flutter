import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:employee_managment_app/models/employee.dart';
import 'package:employee_managment_app/models/department.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employee_management.db');
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
      CREATE TABLE departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        department_id INTEGER NOT NULL,
        joining_date TEXT NOT NULL,
        salary REAL NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE CASCADE
      )
    ''');
    
    // Insert some default departments
    await db.insert('departments', {'name': 'IT'});
    await db.insert('departments', {'name': 'HR'});
    await db.insert('departments', {'name': 'Marketing'});
    await db.insert('departments', {'name': 'Sales'});
  }

  // Department CRUD
  Future<int> addDepartment(Department department) async {
    final db = await instance.database;
    return await db.insert('departments', department.toMap());
  }

  Future<List<Department>> getAllDepartments() async {
    final db = await instance.database;
    final result = await db.query('departments');
    return result.map((json) => Department.fromMap(json)).toList();
  }

  Future<int> updateDepartment(Department department) async {
    final db = await instance.database;
    return await db.update(
      'departments',
      department.toMap(),
      where: 'id = ?',
      whereArgs: [department.id],
    );
  }

  Future<int> deleteDepartment(int id) async {
    final db = await instance.database;
    return await db.delete(
      'departments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Employee CRUD
  Future<int> addEmployee(Employee employee) async {
    final db = await instance.database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> getAllEmployees({String? query, int? departmentId}) async {
    final db = await instance.database;
    
    String sql = '''
      SELECT employees.*, departments.name as departmentName 
      FROM employees 
      JOIN departments ON employees.department_id = departments.id
    ''';
    
    List<dynamic> whereArgs = [];
    if (query != null && query.isNotEmpty) {
      sql += ' WHERE employees.name LIKE ? OR employees.email LIKE ?';
      whereArgs.add('%$query%');
      whereArgs.add('%$query%');
    }
    
    if (departmentId != null) {
      if (whereArgs.isEmpty) {
        sql += ' WHERE employees.department_id = ?';
      } else {
        sql += ' AND employees.department_id = ?';
      }
      whereArgs.add(departmentId);
    }

    final result = await db.rawQuery(sql, whereArgs);
    return result.map((json) => Employee.fromMap(json, json['departmentName'] as String)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await instance.database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Dashboard Stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await instance.database;
    
    final employeeCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM employees')) ?? 0;
    final departmentCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM departments')) ?? 0;
    final totalSalary = (await db.rawQuery('SELECT SUM(salary) as total FROM employees')).first['total'] ?? 0.0;
    final activeEmployees = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM employees WHERE status = ?', ['Active'])) ?? 0;

    return {
      'employeeCount': employeeCount,
      'departmentCount': departmentCount,
      'totalSalary': totalSalary,
      'activeEmployees': activeEmployees,
    };
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
