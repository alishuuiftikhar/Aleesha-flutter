import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../models/resident.dart';
import '../models/visitor.dart';
import '../models/delivery.dart';
import '../models/maintenance.dart';
import '../models/entry_history.dart';
import '../models/reminder.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('apartment_manager.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE residents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        apartment_number TEXT NOT NULL,
        building_block TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        emergency_contact TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE visitors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        purpose TEXT,
        visit_date TEXT NOT NULL,
        expected_arrival_time TEXT,
        expected_departure_time TEXT,
        apartment TEXT,
        number_of_people INTEGER DEFAULT 1,
        vehicle_number TEXT,
        notes TEXT,
        status TEXT DEFAULT 'Expected',
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        delivery_company TEXT NOT NULL,
        tracking_number TEXT,
        package_description TEXT,
        arrival_date TEXT NOT NULL,
        arrival_time TEXT,
        delivery_person_name TEXT,
        delivery_person_phone TEXT,
        status TEXT DEFAULT 'Expected',
        notes TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenance_visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        worker_name TEXT NOT NULL,
        service_type TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT,
        apartment TEXT,
        phone_number TEXT,
        company TEXT,
        purpose TEXT,
        status TEXT DEFAULT 'Scheduled',
        notes TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE entry_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_or_company TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        status TEXT,
        details TEXT,
        related_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        reminder_date TEXT NOT NULL,
        reminder_time TEXT NOT NULL,
        category TEXT DEFAULT 'General',
        is_completed INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT DEFAULT 'General',
        created_at TEXT NOT NULL,
        related_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT
      )
    ''');

    // Seed default data for immediate usability
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final today = DateFormat('yyyy-MM-DD').format(DateTime.now());
    final timeNow = DateFormat('hh:mm a').format(DateTime.now());

    // 1. Default Resident
    await db.insert('residents', {
      'name': 'Alex Morgan',
      'apartment_number': 'Apt 402',
      'building_block': 'Block B',
      'phone_number': '+1 (555) 234-5678',
      'emergency_contact': '+1 (555) 987-6543 (Security Desk)',
      'notes': 'Preferred delivery time after 2 PM.',
    });

    // 2. Sample Visitors
    final visitorId1 = await db.insert('visitors', {
      'name': 'David Miller',
      'phone': '+1 (555) 111-2233',
      'purpose': 'Family Visit',
      'visit_date': today,
      'expected_arrival_time': '10:30 AM',
      'expected_departure_time': '04:00 PM',
      'apartment': 'Apt 402',
      'number_of_people': 2,
      'vehicle_number': 'XYZ-9876',
      'notes': 'Bringing birthday gifts',
      'status': 'Arrived',
      'is_favorite': 1,
    });

    final visitorId2 = await db.insert('visitors', {
      'name': 'Sarah Connor',
      'phone': '+1 (555) 444-5566',
      'purpose': 'Friend Visit',
      'visit_date': today,
      'expected_arrival_time': '06:00 PM',
      'expected_departure_time': '09:00 PM',
      'apartment': 'Apt 402',
      'number_of_people': 1,
      'vehicle_number': 'ABC-1234',
      'notes': 'Call on arrival',
      'status': 'Expected',
      'is_favorite': 0,
    });

    // 3. Sample Deliveries
    final deliveryId1 = await db.insert('deliveries', {
      'delivery_company': 'FedEx Express',
      'tracking_number': 'FX-88992104',
      'package_description': 'Electronics & Gadgets box',
      'arrival_date': today,
      'arrival_time': '11:15 AM',
      'delivery_person_name': 'Robert Green',
      'delivery_person_phone': '+1 (555) 777-8899',
      'status': 'Received',
      'notes': 'Left at lobby security counter',
      'is_favorite': 1,
    });

    await db.insert('deliveries', {
      'delivery_company': 'Amazon Logistics',
      'tracking_number': 'AMZ-44109283',
      'package_description': 'Household Supplies',
      'arrival_date': today,
      'arrival_time': '02:30 PM',
      'delivery_person_name': 'James Wilson',
      'delivery_person_phone': '+1 (555) 333-2211',
      'status': 'Expected',
      'notes': 'Signature required',
      'is_favorite': 0,
    });

    // 4. Sample Maintenance Visit
    await db.insert('maintenance_visits', {
      'worker_name': 'John Vance',
      'service_type': 'AC',
      'date': today,
      'time': '03:00 PM',
      'apartment': 'Apt 402',
      'phone_number': '+1 (555) 888-0000',
      'company': 'Cool Breeze HVAC Services',
      'purpose': 'Quarterly Air Conditioner Service & Filter Replacement',
      'status': 'Scheduled',
      'notes': 'Check living room unit noise level',
      'is_favorite': 1,
    });

    // 5. Entry History
    await db.insert('entry_history', {
      'person_or_company': 'David Miller',
      'type': 'Visitor Arrival',
      'date': today,
      'time': '10:30 AM',
      'status': 'Arrived',
      'details': 'Visitor arrived at gate for Apt 402',
      'related_id': visitorId1,
    });

    await db.insert('entry_history', {
      'person_or_company': 'FedEx Express (Robert Green)',
      'type': 'Delivery Received',
      'date': today,
      'time': '11:15 AM',
      'status': 'Received',
      'details': 'Package FX-88992104 received at lobby desk',
      'related_id': deliveryId1,
    });

    // 6. Reminders
    await db.insert('reminders', {
      'title': 'Pick up FedEx Package',
      'description': 'Collect FedEx package FX-88992104 from security gate desk',
      'reminder_date': today,
      'reminder_time': '05:00 PM',
      'category': 'Delivery',
      'is_completed': 0,
    });

    await db.insert('reminders', {
      'title': 'AC Servicing Technician Visit',
      'description': 'John Vance arriving at 03:00 PM for AC maintenance',
      'reminder_date': today,
      'reminder_time': '02:45 PM',
      'category': 'Maintenance',
      'is_completed': 0,
    });

    // 7. Notes
    await db.insert('notes', {
      'title': 'Gate Pass Code',
      'content': 'Temporary guest pass code for David Miller: #8492',
      'category': 'Visitor',
      'created_at': '$today $timeNow',
      'related_id': visitorId1,
    });

    // 8. Favorites
    await db.insert('favorites', {
      'item_type': 'Visitor',
      'item_id': visitorId1,
      'title': 'David Miller',
      'subtitle': 'Family Visit • Apt 402',
    });

    await db.insert('favorites', {
      'item_type': 'Delivery',
      'item_id': deliveryId1,
      'title': 'FedEx Express',
      'subtitle': 'FX-88992104 • Electronics & Gadgets box',
    });
  }

  // ==========================================
  // RESIDENT OPERATIONS
  // ==========================================
  Future<Resident?> getResident() async {
    final db = await instance.database;
    final maps = await db.query('residents', limit: 1);
    if (maps.isNotEmpty) {
      return Resident.fromMap(maps.first);
    }
    return null;
  }

  Future<int> saveResident(Resident resident) async {
    final db = await instance.database;
    if (resident.id != null) {
      return await db.update('residents', resident.toMap(),
          where: 'id = ?', whereArgs: [resident.id]);
    } else {
      return await db.insert('residents', resident.toMap());
    }
  }

  // ==========================================
  // VISITOR OPERATIONS
  // ==========================================
  Future<List<Visitor>> getAllVisitors({String? searchQuery, String? filterStatus, String? timeframe}) async {
    final db = await instance.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += ' AND (name LIKE ? OR phone LIKE ? OR apartment LIKE ? OR purpose LIKE ?)';
      final query = '%$searchQuery%';
      whereArgs.addAll([query, query, query, query]);
    }

    if (filterStatus != null && filterStatus != 'All') {
      whereClause += ' AND status = ?';
      whereArgs.add(filterStatus);
    }

    if (timeframe != null && timeframe != 'All') {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (timeframe == 'Today') {
        whereClause += ' AND visit_date = ?';
        whereArgs.add(todayStr);
      } else if (timeframe == 'This Week') {
        final now = DateTime.now();
        final startOfWeek = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: now.weekday - 1)));
        final endOfWeek = DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7 - now.weekday)));
        whereClause += ' AND visit_date BETWEEN ? AND ?';
        whereArgs.addAll([startOfWeek, endOfWeek]);
      }
    }

    final result = await db.query('visitors', where: whereClause, whereArgs: whereArgs, orderBy: 'id DESC');
    return result.map((json) => Visitor.fromMap(json)).toList();
  }

  Future<Visitor?> getVisitorById(int id) async {
    final db = await instance.database;
    final result = await db.query('visitors', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Visitor.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertVisitor(Visitor visitor) async {
    final db = await instance.database;
    final id = await db.insert('visitors', visitor.toMap());

    // Create entry log if status is Arrived
    if (visitor.status == 'Arrived') {
      await addEntryHistory(EntryHistory(
        personOrCompany: visitor.name,
        type: 'Visitor Arrival',
        date: visitor.visitDate,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        status: 'Arrived',
        details: 'Purpose: ${visitor.purpose} (${visitor.apartment})',
        relatedId: id,
      ));
    }
    return id;
  }

  Future<int> updateVisitor(Visitor visitor) async {
    final db = await instance.database;
    final result = await db.update('visitors', visitor.toMap(), where: 'id = ?', whereArgs: [visitor.id]);

    // Keep favorite table synced
    if (visitor.isFavorite) {
      await syncFavorite('Visitor', visitor.id!, visitor.name, '${visitor.purpose} • ${visitor.apartment}');
    } else {
      await removeFavorite('Visitor', visitor.id!);
    }
    return result;
  }

  Future<void> updateVisitorStatus(int id, String status) async {
    final db = await instance.database;
    final visitor = await getVisitorById(id);
    if (visitor != null) {
      final updated = visitor.copyWith(status: status);
      await db.update('visitors', updated.toMap(), where: 'id = ?', whereArgs: [id]);

      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final timeStr = DateFormat('hh:mm a').format(DateTime.now());

      if (status == 'Arrived') {
        await addEntryHistory(EntryHistory(
          personOrCompany: visitor.name,
          type: 'Visitor Arrival',
          date: todayStr,
          time: timeStr,
          status: 'Arrived',
          details: 'Marked arrived for ${visitor.apartment}',
          relatedId: id,
        ));
      } else if (status == 'Departed') {
        await addEntryHistory(EntryHistory(
          personOrCompany: visitor.name,
          type: 'Visitor Departure',
          date: todayStr,
          time: timeStr,
          status: 'Departed',
          details: 'Marked departed from ${visitor.apartment}',
          relatedId: id,
        ));
      }
    }
  }

  Future<int> deleteVisitor(int id) async {
    final db = await instance.database;
    await removeFavorite('Visitor', id);
    return await db.delete('visitors', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleVisitorFavorite(Visitor visitor) async {
    final newFav = !visitor.isFavorite;
    await updateVisitor(visitor.copyWith(isFavorite: newFav));
  }

  // ==========================================
  // DELIVERY OPERATIONS
  // ==========================================
  Future<List<Delivery>> getAllDeliveries({String? searchQuery, String? filterStatus, String? timeframe}) async {
    final db = await instance.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += ' AND (delivery_company LIKE ? OR tracking_number LIKE ? OR delivery_person_name LIKE ? OR package_description LIKE ?)';
      final query = '%$searchQuery%';
      whereArgs.addAll([query, query, query, query]);
    }

    if (filterStatus != null && filterStatus != 'All') {
      whereClause += ' AND status = ?';
      whereArgs.add(filterStatus);
    }

    if (timeframe != null && timeframe != 'All') {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (timeframe == 'Today') {
        whereClause += ' AND arrival_date = ?';
        whereArgs.add(todayStr);
      } else if (timeframe == 'This Week') {
        final now = DateTime.now();
        final startOfWeek = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: now.weekday - 1)));
        final endOfWeek = DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7 - now.weekday)));
        whereClause += ' AND arrival_date BETWEEN ? AND ?';
        whereArgs.addAll([startOfWeek, endOfWeek]);
      }
    }

    final result = await db.query('deliveries', where: whereClause, whereArgs: whereArgs, orderBy: 'id DESC');
    return result.map((json) => Delivery.fromMap(json)).toList();
  }

  Future<Delivery?> getDeliveryById(int id) async {
    final db = await instance.database;
    final result = await db.query('deliveries', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Delivery.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertDelivery(Delivery delivery) async {
    final db = await instance.database;
    final id = await db.insert('deliveries', delivery.toMap());

    if (delivery.status == 'Received') {
      await addEntryHistory(EntryHistory(
        personOrCompany: delivery.deliveryCompany,
        type: 'Delivery Received',
        date: delivery.arrivalDate,
        time: delivery.arrivalTime,
        status: 'Received',
        details: 'Package: ${delivery.packageDescription} (${delivery.trackingNumber})',
        relatedId: id,
      ));
    }
    return id;
  }

  Future<int> updateDelivery(Delivery delivery) async {
    final db = await instance.database;
    final result = await db.update('deliveries', delivery.toMap(), where: 'id = ?', whereArgs: [delivery.id]);

    if (delivery.isFavorite) {
      await syncFavorite('Delivery', delivery.id!, delivery.deliveryCompany, '${delivery.trackingNumber} • ${delivery.packageDescription}');
    } else {
      await removeFavorite('Delivery', delivery.id!);
    }
    return result;
  }

  Future<void> updateDeliveryStatus(int id, String status) async {
    final db = await instance.database;
    final delivery = await getDeliveryById(id);
    if (delivery != null) {
      final updated = delivery.copyWith(status: status);
      await db.update('deliveries', updated.toMap(), where: 'id = ?', whereArgs: [id]);

      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final timeStr = DateFormat('hh:mm a').format(DateTime.now());

      String type = 'Delivery Update';
      if (status == 'Received') type = 'Delivery Received';
      if (status == 'Collected') type = 'Package Collected';
      if (status == 'Returned') type = 'Delivery Returned';

      await addEntryHistory(EntryHistory(
        personOrCompany: delivery.deliveryCompany,
        type: type,
        date: todayStr,
        time: timeStr,
        status: status,
        details: 'Package ${delivery.trackingNumber} marked as $status',
        relatedId: id,
      ));
    }
  }

  Future<int> deleteDelivery(int id) async {
    final db = await instance.database;
    await removeFavorite('Delivery', id);
    return await db.delete('deliveries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleDeliveryFavorite(Delivery delivery) async {
    final newFav = !delivery.isFavorite;
    await updateDelivery(delivery.copyWith(isFavorite: newFav));
  }

  // ==========================================
  // MAINTENANCE OPERATIONS
  // ==========================================
  Future<List<MaintenanceVisit>> getAllMaintenance({String? searchQuery, String? filterStatus, String? filterService, String? timeframe}) async {
    final db = await instance.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += ' AND (worker_name LIKE ? OR company LIKE ? OR purpose LIKE ? OR apartment LIKE ?)';
      final query = '%$searchQuery%';
      whereArgs.addAll([query, query, query, query]);
    }

    if (filterStatus != null && filterStatus != 'All') {
      whereClause += ' AND status = ?';
      whereArgs.add(filterStatus);
    }

    if (filterService != null && filterService != 'All') {
      whereClause += ' AND service_type = ?';
      whereArgs.add(filterService);
    }

    if (timeframe != null && timeframe != 'All') {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (timeframe == 'Today') {
        whereClause += ' AND date = ?';
        whereArgs.add(todayStr);
      } else if (timeframe == 'This Week') {
        final now = DateTime.now();
        final startOfWeek = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: now.weekday - 1)));
        final endOfWeek = DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7 - now.weekday)));
        whereClause += ' AND date BETWEEN ? AND ?';
        whereArgs.addAll([startOfWeek, endOfWeek]);
      }
    }

    final result = await db.query('maintenance_visits', where: whereClause, whereArgs: whereArgs, orderBy: 'id DESC');
    return result.map((json) => MaintenanceVisit.fromMap(json)).toList();
  }

  Future<MaintenanceVisit?> getMaintenanceById(int id) async {
    final db = await instance.database;
    final result = await db.query('maintenance_visits', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return MaintenanceVisit.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertMaintenance(MaintenanceVisit item) async {
    final db = await instance.database;
    final id = await db.insert('maintenance_visits', item.toMap());

    if (item.status == 'In Progress' || item.status == 'Completed') {
      await addEntryHistory(EntryHistory(
        personOrCompany: '${item.workerName} (${item.serviceType})',
        type: 'Maintenance Visit',
        date: item.date,
        time: item.time,
        status: item.status,
        details: '${item.purpose} - ${item.company}',
        relatedId: id,
      ));
    }
    return id;
  }

  Future<int> updateMaintenance(MaintenanceVisit item) async {
    final db = await instance.database;
    final result = await db.update('maintenance_visits', item.toMap(), where: 'id = ?', whereArgs: [item.id]);

    if (item.isFavorite) {
      await syncFavorite('Maintenance', item.id!, item.workerName, '${item.serviceType} • ${item.company}');
    } else {
      await removeFavorite('Maintenance', item.id!);
    }
    return result;
  }

  Future<void> updateMaintenanceStatus(int id, String status) async {
    final db = await instance.database;
    final item = await getMaintenanceById(id);
    if (item != null) {
      final updated = item.copyWith(status: status);
      await db.update('maintenance_visits', updated.toMap(), where: 'id = ?', whereArgs: [id]);

      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final timeStr = DateFormat('hh:mm a').format(DateTime.now());

      await addEntryHistory(EntryHistory(
        personOrCompany: '${item.workerName} (${item.serviceType})',
        type: 'Maintenance Visit',
        date: todayStr,
        time: timeStr,
        status: status,
        details: '${item.purpose} marked as $status',
        relatedId: id,
      ));
    }
  }

  Future<int> deleteMaintenance(int id) async {
    final db = await instance.database;
    await removeFavorite('Maintenance', id);
    return await db.delete('maintenance_visits', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleMaintenanceFavorite(MaintenanceVisit item) async {
    final newFav = !item.isFavorite;
    await updateMaintenance(item.copyWith(isFavorite: newFav));
  }

  // ==========================================
  // ENTRY HISTORY OPERATIONS
  // ==========================================
  Future<List<EntryHistory>> getAllEntryHistory({String? searchQuery, String? typeFilter}) async {
    final db = await instance.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += ' AND (person_or_company LIKE ? OR type LIKE ? OR details LIKE ?)';
      final query = '%$searchQuery%';
      whereArgs.addAll([query, query, query]);
    }

    if (typeFilter != null && typeFilter != 'All') {
      whereClause += ' AND type LIKE ?';
      whereArgs.add('%$typeFilter%');
    }

    final result = await db.query('entry_history', where: whereClause, whereArgs: whereArgs, orderBy: 'id DESC');
    return result.map((json) => EntryHistory.fromMap(json)).toList();
  }

  Future<int> addEntryHistory(EntryHistory entry) async {
    final db = await instance.database;
    return await db.insert('entry_history', entry.toMap());
  }

  Future<int> clearEntryHistory() async {
    final db = await instance.database;
    return await db.delete('entry_history');
  }

  // ==========================================
  // REMINDERS OPERATIONS
  // ==========================================
  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;
    final result = await db.query('reminders', orderBy: 'is_completed ASC, reminder_date ASC');
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<int> addReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.update('reminders', reminder.toMap(), where: 'id = ?', whereArgs: [reminder.id]);
  }

  Future<int> toggleReminderCompleted(Reminder reminder) async {
    final updated = reminder.copyWith(isCompleted: !reminder.isCompleted);
    return await updateReminder(updated);
  }

  Future<int> deleteReminder(int id) async {
    final db = await instance.database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // NOTES OPERATIONS
  // ==========================================
  Future<List<AppNote>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((json) => AppNote.fromMap(json)).toList();
  }

  Future<int> addNote(AppNote note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(AppNote note) async {
    final db = await instance.database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // FAVORITES OPERATIONS
  // ==========================================
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await instance.database;
    return await db.query('favorites', orderBy: 'id DESC');
  }

  Future<void> syncFavorite(String type, int itemId, String title, String subtitle) async {
    final db = await instance.database;
    final existing = await db.query('favorites',
        where: 'item_type = ? AND item_id = ?', whereArgs: [type, itemId]);

    if (existing.isEmpty) {
      await db.insert('favorites', {
        'item_type': type,
        'item_id': itemId,
        'title': title,
        'subtitle': subtitle,
      });
    } else {
      await db.update(
        'favorites',
        {'title': title, 'subtitle': subtitle},
        where: 'item_type = ? AND item_id = ?',
        whereArgs: [type, itemId],
      );
    }
  }

  Future<void> removeFavorite(String type, int itemId) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'item_type = ? AND item_id = ?', whereArgs: [type, itemId]);
  }

  // ==========================================
  // CALENDAR & STATS HELPERS
  // ==========================================
  Future<Map<String, List<dynamic>>> getRecordsForDate(String dateStr) async {
    final visitors = await getAllVisitors(timeframe: 'All');
    final deliveries = await getAllDeliveries(timeframe: 'All');
    final maintenance = await getAllMaintenance(timeframe: 'All');

    final dayVisitors = visitors.where((v) => v.visitDate == dateStr).toList();
    final dayDeliveries = deliveries.where((d) => d.arrivalDate == dateStr).toList();
    final dayMaintenance = maintenance.where((m) => m.date == dateStr).toList();

    return {
      'visitors': dayVisitors,
      'deliveries': dayDeliveries,
      'maintenance': dayMaintenance,
    };
  }

  Future<Map<String, int>> getDashboardStats() async {
    final db = await instance.database;
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final todayVisitorsRes = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM visitors WHERE visit_date = ?", [todayStr])) ?? 0;

    final expectedVisitorsRes = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM visitors WHERE status = 'Expected'")) ?? 0;

    final pendingDeliveriesRes = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM deliveries WHERE status IN ('Expected', 'Received')")) ?? 0;

    final maintenanceVisitsRes = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM maintenance_visits WHERE status IN ('Scheduled', 'In Progress')")) ?? 0;

    final totalEntryRecordsRes = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM entry_history")) ?? 0;

    return {
      'today_visitors': todayVisitorsRes,
      'expected_visitors': expectedVisitorsRes,
      'pending_deliveries': pendingDeliveriesRes,
      'maintenance_visits': maintenanceVisitsRes,
      'total_entry_records': totalEntryRecordsRes,
    };
  }

  Future<Map<String, dynamic>> getDetailedStatistics() async {
    final db = await instance.database;
    final now = DateTime.now();
    final startOfWeek = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: now.weekday - 1)));
    final endOfWeek = DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7 - now.weekday)));

    final totalVisitors = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM visitors")) ?? 0;
    final visitorsThisWeek = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM visitors WHERE visit_date BETWEEN ? AND ?", [startOfWeek, endOfWeek])) ?? 0;
    final completedVisits = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM visitors WHERE status = 'Departed'")) ?? 0;

    final totalDeliveries = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM deliveries")) ?? 0;
    final pendingDeliveries = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM deliveries WHERE status IN ('Expected', 'Received')")) ?? 0;
    final collectedDeliveries = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM deliveries WHERE status = 'Collected'")) ?? 0;

    final totalMaintenance = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM maintenance_visits")) ?? 0;
    final completedMaintenance = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM maintenance_visits WHERE status = 'Completed'")) ?? 0;

    final totalEntryRecords = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM entry_history")) ?? 0;

    return {
      'total_visitors': totalVisitors,
      'visitors_this_week': visitorsThisWeek,
      'completed_visits': completedVisits,
      'total_deliveries': totalDeliveries,
      'pending_deliveries': pendingDeliveries,
      'collected_deliveries': collectedDeliveries,
      'total_maintenance': totalMaintenance,
      'completed_maintenance': completedMaintenance,
      'total_entry_records': totalEntryRecords,
    };
  }

  Future<void> clearAllData() async {
    final db = await instance.database;
    await db.delete('visitors');
    await db.delete('deliveries');
    await db.delete('maintenance_visits');
    await db.delete('entry_history');
    await db.delete('reminders');
    await db.delete('notes');
    await db.delete('favorites');
  }
}
