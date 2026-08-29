import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/booking_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bus_reservation.db');
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
      CREATE TABLE buses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        totalSeats INTEGER NOT NULL,
        busNumber TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        busId INTEGER NOT NULL,
        departureCity TEXT NOT NULL,
        destinationCity TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        arrivalTime TEXT NOT NULL,
        basePrice REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (busId) REFERENCES buses (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookingId TEXT NOT NULL,
        routeId INTEGER NOT NULL,
        passengerName TEXT NOT NULL,
        passengerEmail TEXT NOT NULL,
        passengerPhone TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        bookingDate TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (routeId) REFERENCES routes (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE booking_seats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookingId INTEGER NOT NULL,
        seatNumber INTEGER NOT NULL,
        FOREIGN KEY (bookingId) REFERENCES bookings (id)
      )
    ''');

    // Seed Data
    await _seedData(db);
  }

  Future _seedData(Database db) async {
    await db.insert('buses', {
      'name': 'Green Line Express',
      'type': 'AC Sleeper',
      'totalSeats': 40,
      'busNumber': 'GL-101'
    });
    await db.insert('buses', {
      'name': 'Turquoise Travels',
      'type': 'Non-AC',
      'totalSeats': 50,
      'busNumber': 'TT-202'
    });
    await db.insert('buses', {
      'name': 'Orange Odessey',
      'type': 'Luxury AC',
      'totalSeats': 36,
      'busNumber': 'OO-303'
    });

    final List<String> cities = ['New York', 'Boston', 'Washington', 'Philadelphia', 'Chicago'];
    final List<String> dates = ['2026-08-28', '2026-08-29', '2026-08-30'];

    for (var date in dates) {
      for (int i = 0; i < cities.length; i++) {
        for (int j = 0; j < cities.length; j++) {
          if (i != j) {
            await db.insert('routes', {
              'busId': (i % 3) + 1,
              'departureCity': cities[i],
              'destinationCity': cities[j],
              'departureTime': '08:00 AM',
              'arrivalTime': '02:00 PM',
              'basePrice': 45.0 + (i * 5),
              'date': date
            });
          }
        }
      }
    }
  }

  // Bus Operations
  Future<List<Bus>> getAllBuses() async {
    final db = await instance.database;
    final result = await db.query('buses');
    return result.map((json) => Bus.fromMap(json)).toList();
  }

  // Route Operations
  Future<List<Map<String, dynamic>>> searchRoutes(String from, String to, String date) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT routes.*, buses.name as busName, buses.type as busType, buses.totalSeats 
      FROM routes 
      JOIN buses ON routes.busId = buses.id 
      WHERE departureCity = ? AND destinationCity = ? AND date = ?
    ''', [from, to, date]);
  }

  Future<Map<String, dynamic>> getRouteById(int id) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT routes.*, buses.name as busName, buses.type as busType, buses.totalSeats 
      FROM routes 
      JOIN buses ON routes.busId = buses.id 
      WHERE routes.id = ?
    ''', [id]);
    return result.first;
  }

  // Booking Operations
  Future<int> createBooking(Booking booking, List<int> selectedSeats) async {
    final db = await instance.database;
    return await db.transaction((txn) async {
      final bookingId = await txn.insert('bookings', booking.toMap());
      for (var seat in selectedSeats) {
        await txn.insert('booking_seats', {
          'bookingId': bookingId,
          'seatNumber': seat,
        });
      }
      return bookingId;
    });
  }

  Future<List<int>> getBookedSeats(int routeId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT seatNumber FROM booking_seats 
      JOIN bookings ON booking_seats.bookingId = bookings.id 
      WHERE bookings.routeId = ? AND bookings.status != 'Cancelled'
    ''', [routeId]);
    return result.map((row) => row['seatNumber'] as int).toList();
  }

  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT bookings.*, routes.departureCity, routes.destinationCity, routes.departureTime, routes.date
      FROM bookings
      JOIN routes ON bookings.routeId = routes.id
      ORDER BY bookings.id DESC
    ''');
  }

  Future<Map<String, dynamic>> getBookingDetails(int id) async {
    final db = await instance.database;
    final booking = await db.rawQuery('''
      SELECT bookings.*, routes.departureCity, routes.destinationCity, routes.departureTime, routes.arrivalTime, routes.date, buses.name as busName, buses.busNumber
      FROM bookings
      JOIN routes ON bookings.routeId = routes.id
      JOIN buses ON routes.busId = buses.id
      WHERE bookings.id = ?
    ''', [id]);
    
    final seats = await db.query('booking_seats', where: 'bookingId = ?', whereArgs: [id]);
    
    Map<String, dynamic> result = Map.from(booking.first);
    result['seats'] = seats.map((s) => s['seatNumber']).toList();
    return result;
  }

  Future<int> cancelBooking(int id) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      {'status': 'Cancelled'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
