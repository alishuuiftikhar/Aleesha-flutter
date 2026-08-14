import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pet.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('petpal_v3.db');
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
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        breed TEXT NOT NULL,
        age TEXT NOT NULL,
        distance TEXT NOT NULL,
        imagePath TEXT,
        category TEXT NOT NULL,
        description TEXT,
        isFavorite INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        price TEXT NOT NULL,
        imagePath TEXT,
        category TEXT NOT NULL,
        description TEXT
      )
    ''');

    await _insertInitialData(db);
  }

  Future _insertInitialData(Database db) async {
    final dogImages = [
      'https://images.unsplash.com/photo-1552053831-71594a27632d', 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
      'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8', 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee',
      'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7', 'https://images.unsplash.com/photo-1543466835-00a7907e9ef1',
      'https://images.unsplash.com/photo-1517849845537-4d257902454a', 'https://images.unsplash.com/photo-1587300003388-59208cc962cb',
      'https://images.unsplash.com/photo-1534361960057-19889db9621e', 'https://images.unsplash.com/photo-1561037404-61cd46aa615b',
      'https://images.unsplash.com/photo-1507146426996-ef05306b995a', 'https://images.unsplash.com/photo-1530281700549-e82e7bf110d6',
      'https://images.unsplash.com/photo-1512723185835-0700e5069a9a', 'https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a',
      'https://images.unsplash.com/photo-1544568100-847a948585b9'
    ];
    final dogNames = ['Max', 'Bella', 'Charlie', 'Luna', 'Rocky', 'Daisy', 'Cooper', 'Milo', 'Bailey', 'Lucy', 'Buddy', 'Bear', 'Sadie', 'Tucker', 'Zoe'];
    final dogBreeds = ['Golden Retriever', 'Poodle', 'Beagle', 'Husky', 'Bulldog', 'Dachshund', 'Labrador', 'Shih Tzu', 'Cocker Spaniel', 'Chihuahua', 'German Shepherd', 'Chow Chow', 'Boxer', 'French Bulldog', 'Pomeranian'];

    for (int i = 0; i < 15; i++) {
      await db.insert('pets', Pet(name: dogNames[i], breed: dogBreeds[i], age: '${(i%3)+1} years', distance: '${(i*0.4+0.5).toStringAsFixed(1)} km', category: 'Dogs', imagePath: '${dogImages[i]}?q=80&w=500', description: 'A wonderful dog looking for a home.').toMap());
    }

    final catImages = [
      'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba', 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d',
      'https://images.unsplash.com/photo-1533738363-b7f9aef128ce', 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13',
      'https://images.unsplash.com/photo-1573865662567-57ef8b34518e', 'https://images.unsplash.com/photo-1519052537078-e6302a4968d4',
      'https://images.unsplash.com/photo-1511495284982-442c22956c7d', 'https://images.unsplash.com/photo-1548247416-ec66f4900b2e',
      'https://images.unsplash.com/photo-1533743983669-94fa5c4338ec', 'https://images.unsplash.com/photo-1513245543132-31f507417b26',
      'https://images.unsplash.com/photo-1517331156700-3c241d2b4d83', 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2',
      'https://images.unsplash.com/photo-1535241639428-102607ba479e', 'https://images.unsplash.com/photo-1501820488136-72669149e0d4',
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131'
    ];
    for (int i = 0; i < 15; i++) {
      await db.insert('pets', Pet(name: 'Cat ${i+1}', breed: i % 2 == 0 ? 'Persian' : 'Siamese', age: '${(i%2)+1} years', distance: '${(i*0.3+1.2).toStringAsFixed(1)} km', category: 'Cats', imagePath: '${catImages[i]}?q=80&w=500', description: 'A lovely cat looking for a home.').toMap());
    }

    final birdImages = [
      'https://images.unsplash.com/photo-1522926193341-e9fed6c10e8f', 'https://images.unsplash.com/photo-1444464666168-49d633b86797',
      'https://images.unsplash.com/photo-1552728089-57bdde30ebe3', 'https://images.unsplash.com/photo-1516233501032-2485dc1cc6a2',
      'https://images.unsplash.com/photo-1452570053594-1b985d6ea890', 'https://images.unsplash.com/photo-1548366086-7f1b76106622',
      'https://images.unsplash.com/photo-1618331835717-801e976710b2', 'https://images.unsplash.com/photo-1555000395-8828277bc593',
      'https://images.unsplash.com/photo-1480044965905-02098d419e96', 'https://images.unsplash.com/photo-1551085254-e96b210db58a',
      'https://images.unsplash.com/photo-1544158934-842ca07b5936', 'https://images.unsplash.com/photo-1517101724602-c257fe568127',
      'https://images.unsplash.com/photo-1470619549108-b85c56fe5be8', 'https://images.unsplash.com/photo-1550159930-40066082a4fc',
      'https://images.unsplash.com/photo-1520808663317-647b476a81b9'
    ];
    for (int i = 0; i < 15; i++) {
      await db.insert('pets', Pet(name: 'Bird ${i+1}', breed: i % 2 == 0 ? 'Parrot' : 'Canary', age: '${(i%5)+1} months', distance: '${(i*0.2+0.8).toStringAsFixed(1)} km', category: 'Birds', imagePath: '${birdImages[i]}?q=80&w=500', description: 'Colorful and chirpy friend.').toMap());
    }

    final productImages = [
      'https://images.unsplash.com/photo-1589924691106-073b697596cd', 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1',
      'https://images.unsplash.com/photo-1585503418537-88331351ad99', 'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd',
      'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55', 'https://images.unsplash.com/photo-1591769225440-811ad7d6eca3',
      'https://images.unsplash.com/photo-1583337130417-3346a1be7dee', 'https://images.unsplash.com/photo-1623333333333-333333333333',
      'https://images.unsplash.com/photo-1581447100512-67508112595b', 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
      'https://images.unsplash.com/photo-1560743641-3914f2c45636', 'https://images.unsplash.com/photo-1597843786271-290022f46261',
      'https://images.unsplash.com/photo-1583512603805-3cc6b41f3edb', 'https://images.unsplash.com/photo-1516453174212-618467df23d6',
      'https://images.unsplash.com/photo-1583336663277-620dc1996580', 'https://images.unsplash.com/photo-1583512603866-910c8542ba18',
      'https://images.unsplash.com/photo-1583337130417-3346a1be7dee', 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
      'https://images.unsplash.com/photo-1583336663277-620dc1996580', 'https://images.unsplash.com/photo-1583512603866-910c8542ba18'
    ];

    for (int i = 0; i < 20; i++) {
      String cat = (i < 7) ? 'Dog Food' : (i < 14 ? 'Cat Food' : 'Bird Food');
      await db.insert('products', {
        'name': 'Premium ${cat} Pack ${i+1}',
        'brand': 'PetPal Nutri',
        'price': '\$${(i+1)*4}.99',
        'imagePath': '${productImages[i]}?q=80&w=500',
        'category': cat,
        'description': 'Best nutrition for your pet.'
      });
    }
  }

  Future<List<Pet>> getAllPets() async {
    final db = await instance.database;
    final result = await db.query('pets');
    return result.map((json) => Pet.fromMap(json)).toList();
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await instance.database;
    return await db.update('pets', {'isFavorite': isFavorite ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }
}
