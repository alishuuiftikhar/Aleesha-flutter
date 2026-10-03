import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bike_rental.db');
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
      CREATE TABLE bikes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        frame_size TEXT NOT NULL,
        price_per_day REAL NOT NULL,
        status TEXT NOT NULL,
        image_url TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        id_number TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rentals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        total_price REAL NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE rental_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rental_id INTEGER NOT NULL,
        bike_id INTEGER NOT NULL,
        price_per_day REAL NOT NULL,
        FOREIGN KEY (rental_id) REFERENCES rentals (id) ON DELETE CASCADE,
        FOREIGN KEY (bike_id) REFERENCES bikes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bike_id INTEGER NOT NULL,
        maintenance_date TEXT NOT NULL,
        description TEXT NOT NULL,
        cost REAL NOT NULL,
        notes TEXT,
        FOREIGN KEY (bike_id) REFERENCES bikes (id) ON DELETE CASCADE
      )
    ''');

    // Seed Initial Data
    await _seedData(db);
  }

  Future _seedData(Database db) async {
    // Seed Bikes
    final bikesData = [
      {
        'name': 'Trek Marlin 7',
        'category': 'Mountain',
        'frame_size': 'M',
        'price_per_day': 25.0,
        'status': 'Available',
        'image_url': 'https://images.unsplash.com/photo-1544192240-4a34fed0104c?w=600&auto=format&fit=crop&q=60',
        'description': 'High-performance mountain bike suited for rugged trails with hydraulic disc brakes and a smooth suspension fork.'
      },
      {
        'name': 'Specialized Allez',
        'category': 'Road',
        'frame_size': 'L',
        'price_per_day': 30.0,
        'status': 'Available',
        'image_url': 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=600&auto=format&fit=crop&q=60',
        'description': 'Lightweight premium road bike optimized for speed, distance, and crisp gear shifting on smooth asphalt.'
      },
      {
        'name': 'Cannondale Quick 4',
        'category': 'Hybrid',
        'frame_size': 'M',
        'price_per_day': 20.0,
        'status': 'Rented',
        'image_url': 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?w=600&auto=format&fit=crop&q=60',
        'description': 'A versatile and comfortable hybrid bicycle, perfect for city commuting, fitness tracking, and casual errands.'
      },
      {
        'name': 'Rad Power RadRunner 2',
        'category': 'Electric',
        'frame_size': 'One Size',
        'price_per_day': 45.0,
        'status': 'Available',
        'image_url': 'https://images.unsplash.com/photo-1571068316341-2f8ed96da604?w=600&auto=format&fit=crop&q=60',
        'description': 'Heavy-duty electric utility bike featuring multiple pedal assist levels, a throttle, and substantial cargo capacity.'
      },
      {
        'name': 'Santa Cruz Tallboy',
        'category': 'Mountain',
        'frame_size': 'XL',
        'price_per_day': 55.0,
        'status': 'Maintenance',
        'image_url': 'https://images.unsplash.com/photo-1576435465679-644737be6074?w=600&auto=format&fit=crop&q=60',
        'description': 'Top-tier dual suspension mountain bike engineered to dominate downhill descents and technical singletrack.'
      },
      {
        'name': 'GT Performer BMX',
        'category': 'BMX',
        'frame_size': 'S',
        'price_per_day': 15.0,
        'status': 'Available',
        'image_url': 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=600&auto=format&fit=crop&q=60',
        'description': 'Classic, robust freestyle BMX bike ideal for skatepark tricks, street riding, and dirt jump stunts.'
      },
      {
        'name': 'Giant Escape 3',
        'category': 'Hybrid',
        'frame_size': 'L',
        'price_per_day': 18.0,
        'status': 'Available',
        'image_url': 'https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?w=600&auto=format&fit=crop&q=60',
        'description': 'Reliable aluminum-frame hybrid bicycle providing stable, confident handling across varied city streets.'
      }
    ];

    for (var bike in bikesData) {
      await db.insert('bikes', bike);
    }

    // Seed Customers
    final customersData = [
      {
        'name': 'John Doe',
        'email': 'john.doe@gmail.com',
        'phone': '+1 (555) 019-2834',
        'id_number': 'DL-9874521',
        'address': '742 Evergreen Terrace, Springfield'
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@yahoo.com',
        'phone': '+1 (555) 014-9988',
        'id_number': 'PASSPORT-8827',
        'address': '10 Downing Street, Westminster'
      },
      {
        'name': 'Marcus Vance',
        'email': 'marcus.v@outlook.com',
        'phone': '+1 (555) 017-3344',
        'id_number': 'ID-4491029',
        'address': '52 Pine Road, Seattle, WA'
      }
    ];

    for (var customer in customersData) {
      await db.insert('customers', customer);
    }

    // Seed a couple of rentals
    // Rental 1: Marcus Vance rented Cannondale Quick 4 (id=3)
    final now = DateTime.now();
    final startDate1 = now.subtract(const Duration(days: 2)).toIso8601String();
    final endDate1 = now.add(const Duration(days: 2)).toIso8601String();
    
    int rentalId1 = await db.insert('rentals', {
      'customer_id': 3,
      'start_date': startDate1,
      'end_date': endDate1,
      'total_price': 80.0, // 4 days * 20.0
      'status': 'Active',
      'notes': 'Requested a helmet and cable lock.'
    });

    await db.insert('rental_items', {
      'rental_id': rentalId1,
      'bike_id': 3,
      'price_per_day': 20.0
    });

    // Rental 2: Historical Completed Rental
    final prevStart = now.subtract(const Duration(days: 10)).toIso8601String();
    final prevEnd = now.subtract(const Duration(days: 7)).toIso8601String();
    int rentalId2 = await db.insert('rentals', {
      'customer_id': 1,
      'start_date': prevStart,
      'end_date': prevEnd,
      'total_price': 75.0, // 3 days * 25.0
      'status': 'Completed',
      'notes': 'Returned on time, bike in perfect condition.'
    });

    await db.insert('rental_items', {
      'rental_id': rentalId2,
      'bike_id': 1,
      'price_per_day': 25.0
    });

    // Seed Maintenance Record for Santa Cruz Tallboy (id=5)
    await db.insert('maintenance_records', {
      'bike_id': 5,
      'maintenance_date': now.subtract(const Duration(days: 1)).toIso8601String(),
      'description': 'Rear shock air sleeve service and front brake pad replacement.',
      'cost': 120.0,
      'notes': 'Waiting for part delivery to finish calibration.'
    });
  }

  // --- BIKES CRUD ---
  Future<List<Map<String, dynamic>>> getAllBikes() async {
    final db = await instance.database;
    return await db.query('bikes', orderBy: 'name ASC');
  }

  Future<int> insertBike(Map<String, dynamic> bike) async {
    final db = await instance.database;
    return await db.insert('bikes', bike);
  }

  Future<int> updateBike(int id, Map<String, dynamic> bike) async {
    final db = await instance.database;
    return await db.update('bikes', bike, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBike(int id) async {
    final db = await instance.database;
    return await db.delete('bikes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBikeStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update('bikes', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  // --- CUSTOMERS CRUD ---
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await instance.database;
    return await db.query('customers', orderBy: 'name ASC');
  }

  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer);
  }

  Future<int> updateCustomer(int id, Map<String, dynamic> customer) async {
    final db = await instance.database;
    return await db.update('customers', customer, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // --- RENTALS OPERATIONS ---
  Future<List<Map<String, dynamic>>> getAllRentals() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT r.*, c.name as customer_name, c.email as customer_email, c.phone as customer_phone
      FROM rentals r
      JOIN customers c ON r.customer_id = c.id
      ORDER BY r.start_date DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getRentalItems(int rentalId) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT ri.*, b.name as bike_name, b.category as bike_category, b.image_url as bike_image
      FROM rental_items ri
      JOIN bikes b ON ri.bike_id = b.id
      WHERE ri.rental_id = ?
    ''', [rentalId]);
  }

  Future<bool> bookRental({
    required int customerId,
    required List<int> bikeIds,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    String? notes,
  }) async {
    final db = await instance.database;
    
    // Start a transaction
    return await db.transaction((txn) async {
      // 1. Double check all bikes are still available
      for (int bikeId in bikeIds) {
        final bikeRes = await txn.query('bikes', columns: ['status'], where: 'id = ?', whereArgs: [bikeId]);
        if (bikeRes.isEmpty || bikeRes.first['status'] != 'Available') {
          return false; // Bike is not available
        }
      }

      // 2. Insert rental row
      int rentalId = await txn.insert('rentals', {
        'customer_id': customerId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'total_price': totalPrice,
        'status': 'Active',
        'notes': notes ?? '',
      });

      // 3. Insert rental items and update bike status
      for (int bikeId in bikeIds) {
        // Find bike's price per day
        final bikeRes = await txn.query('bikes', columns: ['price_per_day'], where: 'id = ?', whereArgs: [bikeId]);
        double pricePerDay = (bikeRes.first['price_per_day'] as num).toDouble();

        await txn.insert('rental_items', {
          'rental_id': rentalId,
          'bike_id': bikeId,
          'price_per_day': pricePerDay,
        });

        await txn.update('bikes', {'status': 'Rented'}, where: 'id = ?', whereArgs: [bikeId]);
      }

      return true;
    });
  }

  Future<void> returnRental(int rentalId, {String? damageNotes, double? maintenanceCost}) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      // 1. Update rental status to Completed
      await txn.update('rentals', {'status': 'Completed'}, where: 'id = ?', whereArgs: [rentalId]);

      // 2. Find all bikes in this rental
      final items = await txn.query('rental_items', columns: ['bike_id'], where: 'rental_id = ?', whereArgs: [rentalId]);

      for (var item in items) {
        int bikeId = item['bike_id'] as int;

        if (damageNotes != null && damageNotes.trim().isNotEmpty) {
          // If there is damage, change status to Maintenance and log maintenance record
          await txn.update('bikes', {'status': 'Maintenance'}, where: 'id = ?', whereArgs: [bikeId]);
          await txn.insert('maintenance_records', {
            'bike_id': bikeId,
            'maintenance_date': DateTime.now().toIso8601String(),
            'description': 'Damage noted upon return: $damageNotes',
            'cost': maintenanceCost ?? 0.0,
            'notes': 'Logged automatically on bike return.'
          });
        } else {
          // Otherwise change back to Available
          await txn.update('bikes', {'status': 'Available'}, where: 'id = ?', whereArgs: [bikeId]);
        }
      }
    });
  }

  Future<void> cancelRental(int rentalId) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      // Update status to Cancelled
      await txn.update('rentals', {'status': 'Cancelled'}, where: 'id = ?', whereArgs: [rentalId]);

      // Return rented bikes back to Available
      final items = await txn.query('rental_items', columns: ['bike_id'], where: 'rental_id = ?', whereArgs: [rentalId]);
      for (var item in items) {
        int bikeId = item['bike_id'] as int;
        await txn.update('bikes', {'status': 'Available'}, where: 'id = ?', whereArgs: [bikeId]);
      }
    });
  }

  // --- MAINTENANCE CRUD ---
  Future<List<Map<String, dynamic>>> getMaintenanceRecords() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT m.*, b.name as bike_name, b.category as bike_category, b.image_url as bike_image
      FROM maintenance_records m
      JOIN bikes b ON m.bike_id = b.id
      ORDER BY m.maintenance_date DESC
    ''');
  }

  Future<int> insertMaintenanceRecord(Map<String, dynamic> record) async {
    final db = await instance.database;
    return await db.insert('maintenance_records', record);
  }

  Future<void> resolveMaintenance(int recordId, int bikeId, String notes) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.update('maintenance_records', {'notes': 'Resolved: $notes'}, where: 'id = ?', whereArgs: [recordId]);
      await txn.update('bikes', {'status': 'Available'}, where: 'id = ?', whereArgs: [bikeId]);
    });
  }

  // --- STATISTICS AND ANALYTICS ---
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await instance.database;

    // 1. Total Earnings from Completed and Active rentals
    final earningsRes = await db.rawQuery("SELECT SUM(total_price) as total FROM rentals WHERE status != 'Cancelled'");
    double totalEarnings = (earningsRes.first['total'] as num?)?.toDouble() ?? 0.0;

    // 2. Total active rentals
    final activeRes = await db.rawQuery("SELECT COUNT(*) as count FROM rentals WHERE status = 'Active'");
    int activeRentals = Sqflite.firstIntValue(activeRes) ?? 0;

    // 3. Count of bikes by status
    final bikesRes = await db.rawQuery("SELECT status, COUNT(*) as count FROM bikes GROUP BY status");
    int availableBikes = 0;
    int rentedBikes = 0;
    int maintenanceBikes = 0;

    for (var r in bikesRes) {
      if (r['status'] == 'Available') availableBikes = r['count'] as int;
      if (r['status'] == 'Rented') rentedBikes = r['count'] as int;
      if (r['status'] == 'Maintenance') maintenanceBikes = r['count'] as int;
    }

    // 4. Total Customers count
    final custRes = await db.rawQuery("SELECT COUNT(*) as count FROM customers");
    int totalCustomers = Sqflite.firstIntValue(custRes) ?? 0;

    // 5. Category counts for chart/breakdown
    final catRes = await db.rawQuery("SELECT category, COUNT(*) as count FROM bikes GROUP BY category");
    List<Map<String, dynamic>> categoryBreakdown = catRes;

    return {
      'totalEarnings': totalEarnings,
      'activeRentals': activeRentals,
      'availableBikes': availableBikes,
      'rentedBikes': rentedBikes,
      'maintenanceBikes': maintenanceBikes,
      'totalCustomers': totalCustomers,
      'categoryBreakdown': categoryBreakdown,
    };
  }
}
