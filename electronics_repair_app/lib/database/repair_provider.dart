import 'package:flutter/material.dart';
import 'database_helper.dart';
import '../models/customer.dart';
import '../models/device.dart';
import '../models/repair_order.dart';
import '../models/technician.dart';
import '../models/part.dart';
import '../models/payment.dart';

class RepairProvider with ChangeNotifier {
  List<Customer> _customers = [];
  List<Device> _devices = [];
  List<Map<String, dynamic>> _repairOrders = [];
  List<Technician> _technicians = [];
  List<Part> _parts = [];

  List<Customer> get customers => _customers;
  List<Device> get devices => _devices;
  List<Map<String, dynamic>> get repairOrders => _repairOrders;
  List<Technician> get technicians => _technicians;
  List<Part> get parts => _parts;

  Future<void> fetchAllData() async {
    final db = DatabaseHelper.instance;
    
    final customerData = await db.queryAllRows('customers');
    _customers = customerData.map((e) => Customer.fromMap(e)).toList();

    final deviceData = await db.queryAllRows('devices');
    _devices = deviceData.map((e) => Device.fromMap(e)).toList();

    _repairOrders = await db.getRepairOrdersWithDetails();

    final techData = await db.queryAllRows('technicians');
    _technicians = techData.map((e) => Technician.fromMap(e)).toList();

    final partData = await db.queryAllRows('parts');
    _parts = partData.map((e) => Part.fromMap(e)).toList();

    notifyListeners();
  }

  // Customers
  Future<void> addCustomer(Customer customer) async {
    await DatabaseHelper.instance.insert('customers', customer.toMap());
    await fetchAllData();
  }

  // Devices
  Future<void> addDevice(Device device) async {
    await DatabaseHelper.instance.insert('devices', device.toMap());
    await fetchAllData();
  }

  // Repair Orders
  Future<void> addRepairOrder(RepairOrder order) async {
    await DatabaseHelper.instance.insert('repair_orders', order.toMap());
    await fetchAllData();
  }

  Future<void> updateRepairStatus(int id, RepairStatus status) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'repair_orders',
      {'status': status.name, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAllData();
  }
  
  Future<void> deleteRepairOrder(int id) async {
    await DatabaseHelper.instance.delete('repair_orders', id);
    await fetchAllData();
  }

  // Parts
  Future<void> addPart(Part part) async {
    await DatabaseHelper.instance.insert('parts', part.toMap());
    await fetchAllData();
  }

  // Revenue
  Future<double> getRevenue() async {
    return await DatabaseHelper.instance.getTotalRevenue();
  }
  
  // Stats
  int getPendingRepairsCount() {
    return _repairOrders.where((element) => element['status'] != 'Delivered' && element['status'] != 'Cancelled').length;
  }
}
