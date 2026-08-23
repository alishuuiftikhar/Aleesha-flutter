import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact_model.dart';
import '../models/group_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const integerTypeNullable = 'INTEGER';

    await db.execute('''
CREATE TABLE groups (
  id $idType,
  name $textType
)
''');

    await db.execute('''
CREATE TABLE contacts (
  id $idType,
  name $textType,
  phoneNumber $textType,
  email $textTypeNullable,
  address $textTypeNullable,
  notes $textTypeNullable,
  avatar $textTypeNullable,
  isFavorite $boolType,
  groupId $integerTypeNullable,
  FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE SET NULL
)
''');
  }

  // Group Operations
  Future<int> createGroup(GroupModel group) async {
    final db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<List<GroupModel>> readAllGroups() async {
    final db = await instance.database;
    final result = await db.query('groups');
    return result.map((json) => GroupModel.fromMap(json)).toList();
  }

  Future<int> updateGroup(GroupModel group) async {
    final db = await instance.database;
    return db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<int> deleteGroup(int id) async {
    final db = await instance.database;
    return await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Contact Operations
  Future<int> createContact(ContactModel contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<ContactModel>> readAllContacts({String? query, String? sortBy}) async {
    final db = await instance.database;
    String? where;
    List<dynamic>? whereArgs;

    if (query != null && query.isNotEmpty) {
      where = 'name LIKE ? OR phoneNumber LIKE ?';
      whereArgs = ['%$query%', '%$query%'];
    }

    String orderBy = 'name ASC';
    if (sortBy == 'name_desc') {
      orderBy = 'name DESC';
    }

    final result = await db.query('contacts', where: where, whereArgs: whereArgs, orderBy: orderBy);
    return result.map((json) => ContactModel.fromMap(json)).toList();
  }

  Future<List<ContactModel>> readFavorites() async {
    final db = await instance.database;
    final result = await db.query('contacts', where: 'isFavorite = ?', whereArgs: [1], orderBy: 'name ASC');
    return result.map((json) => ContactModel.fromMap(json)).toList();
  }

  Future<List<ContactModel>> readContactsByGroup(int groupId) async {
    final db = await instance.database;
    final result = await db.query('contacts', where: 'groupId = ?', whereArgs: [groupId], orderBy: 'name ASC');
    return result.map((json) => ContactModel.fromMap(json)).toList();
  }

  Future<int> updateContact(ContactModel contact) async {
    final db = await instance.database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ContactModel?> readContact(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'contacts',
      columns: ['id', 'name', 'phoneNumber', 'email', 'address', 'notes', 'avatar', 'isFavorite', 'groupId'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ContactModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
