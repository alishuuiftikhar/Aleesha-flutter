import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('invoice_pro.db');
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
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        unit TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id TEXT PRIMARY KEY,
        customer_id TEXT,
        date TEXT,
        due_date TEXT,
        status TEXT,
        subtotal REAL,
        tax REAL,
        discount REAL,
        total REAL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoice_items (
        id TEXT PRIMARY KEY,
        invoice_id TEXT,
        product_id TEXT,
        quantity INTEGER,
        unit_price REAL,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        invoice_id TEXT,
        date TEXT,
        amount REAL,
        method TEXT
      )
    ''');
  }

  // --- Customers ---
  Future<List<Customer>> getCustomers() async {
    final db = await instance.database;
    final res = await db.query('customers', orderBy: 'name');
    return res.map((json) => Customer.fromJson(json)).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    final db = await instance.database;
    final map = customer.toJson();
    map['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert('customers', map);
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await instance.database;
    await db.update('customers', customer.toJson(), where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<void> deleteCustomer(String id) async {
    final db = await instance.database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // --- Products ---
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final res = await db.query('products', orderBy: 'name');
    return res.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> addProduct(Product product) async {
    final db = await instance.database;
    final map = product.toJson();
    map['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert('products', map);
  }

  Future<void> updateProduct(Product product) async {
    final db = await instance.database;
    await db.update('products', product.toJson(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(String id) async {
    final db = await instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // --- Invoices ---
  Future<List<Invoice>> getInvoices() async {
    final db = await instance.database;
    final res = await db.query('invoices', orderBy: 'date DESC');
    return res.map((json) => Invoice.fromJson(json)).toList();
  }

  Future<void> createInvoice(Invoice invoice, List<InvoiceItem> items) async {
    final db = await instance.database;
    final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final invoiceMap = invoice.toJson();
    invoiceMap['id'] = invoiceId;
    await db.insert('invoices', invoiceMap);

    for (var item in items) {
      final itemMap = item.toJson();
      itemMap['id'] = DateTime.now().millisecondsSinceEpoch.toString() + items.indexOf(item).toString();
      itemMap['invoice_id'] = invoiceId;
      await db.insert('invoice_items', itemMap);
    }
  }

  Future<void> deleteInvoice(String id) async {
    final db = await instance.database;
    await db.delete('invoice_items', where: 'invoice_id = ?', whereArgs: [id]);
    await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<InvoiceItem>> getInvoiceItems(String invoiceId) async {
    final db = await instance.database;
    final res = await db.query('invoice_items', where: 'invoice_id = ?', whereArgs: [invoiceId]);
    return res.map((json) => InvoiceItem.fromJson(json)).toList();
  }

  // --- Payments ---
  Future<List<Payment>> getPayments(String invoiceId) async {
    final db = await instance.database;
    final res = await db.query('payments', where: 'invoice_id = ?', whereArgs: [invoiceId]);
    return res.map((json) => Payment.fromJson(json)).toList();
  }

  Future<void> addPayment(Payment payment) async {
    final db = await instance.database;
    final map = payment.toJson();
    map['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert('payments', map);
    await _updateInvoiceStatus(payment.invoiceId);
  }

  Future<void> _updateInvoiceStatus(String invoiceId) async {
    final db = await instance.database;
    final invoiceRes = await db.query('invoices', where: 'id = ?', whereArgs: [invoiceId]);
    if (invoiceRes.isEmpty) return;
    final invoice = Invoice.fromJson(Map<String, dynamic>.from(invoiceRes.first));

    final paymentsRes = await db.query('payments', where: 'invoice_id = ?', whereArgs: [invoiceId]);
    final payments = paymentsRes.map((json) => Payment.fromJson(Map<String, dynamic>.from(json))).toList();

    double totalPaid = payments.fold(0, (sum, p) => sum + p.amount);

    String newStatus = 'unpaid';
    if (totalPaid >= invoice.total) {
      newStatus = 'paid';
    } else if (totalPaid > 0) {
      newStatus = 'partial';
    } else if (invoice.dueDate.isBefore(DateTime.now())) {
      newStatus = 'overdue';
    }

    await db.update(
      'invoices',
      <String, Object?>{'status': newStatus},
      where: 'id = ?',
      whereArgs: [invoiceId],
    );
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final invoices = await getInvoices();
    double totalRevenue = invoices.where((i) => i.status == 'paid').fold(0, (sum, i) => sum + i.total);
    double pendingAmount = invoices.where((i) => i.status != 'paid').fold(0, (sum, i) => sum + i.total);
    
    return {
      'totalInvoices': invoices.length,
      'totalRevenue': totalRevenue,
      'pendingAmount': pendingAmount,
      'paidCount': invoices.where((i) => i.status == 'paid').length,
      'unpaidCount': invoices.where((i) => i.status != 'paid').length,
    };
  }
}
