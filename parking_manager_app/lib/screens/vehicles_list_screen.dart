import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final data = await _dbHelper.queryAll('vehicles');
    setState(() {
      _vehicles = data;
    });
  }

  Future<void> _deleteVehicle(int id) async {
    await _dbHelper.delete('vehicles', 'id = ?', [id]);
    _loadVehicles();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Registered Vehicles', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.secondary, child: Icon(Icons.directions_car, color: Colors.white)),
              title: Text(vehicle['plate_number'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${vehicle['vehicle_type']} - ${vehicle['model']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteVehicle(vehicle['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
