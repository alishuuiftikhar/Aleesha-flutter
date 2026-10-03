import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'database_helper.dart';

class AppProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  
  List<Customer> customers = [];
  List<Product> products = [];
  List<Invoice> invoices = [];
  Map<String, dynamic> stats = {};
  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    _setLoading(true);
    try {
      customers = await _db.getCustomers();
      products = await _db.getProducts();
      invoices = await _db.getInvoices();
      stats = await _db.getDashboardStats();
    } catch (e) {
      debugPrint('Error fetching data from SQLite: $e');
    }
    _setLoading(false);
  }

  // Customer methods
  Future<void> addCustomer(Customer customer) async {
    await _db.addCustomer(customer);
    await fetchData();
  }
  
  Future<void> updateCustomer(Customer customer) async {
    await _db.updateCustomer(customer);
    await fetchData();
  }

  Future<void> deleteCustomer(String id) async {
    await _db.deleteCustomer(id);
    await fetchData();
  }

  // Product methods
  Future<void> addProduct(Product product) async {
    await _db.addProduct(product);
    await fetchData();
  }

  Future<void> updateProduct(Product product) async {
    await _db.updateProduct(product);
    await fetchData();
  }

  Future<void> deleteProduct(String id) async {
    await _db.deleteProduct(id);
    await fetchData();
  }

  // Invoice methods
  Future<void> createInvoice(Invoice invoice, List<InvoiceItem> items) async {
    await _db.createInvoice(invoice, items);
    await fetchData();
  }

  Future<void> deleteInvoice(String id) async {
    await _db.deleteInvoice(id);
    await fetchData();
  }
  
  Future<List<InvoiceItem>> getInvoiceItems(String invoiceId) async {
    return await _db.getInvoiceItems(invoiceId);
  }

  Future<void> addPayment(Payment payment) async {
    await _db.addPayment(payment);
    await fetchData();
  }
}
