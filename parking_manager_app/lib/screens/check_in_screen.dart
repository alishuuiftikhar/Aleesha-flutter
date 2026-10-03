import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';
import 'package:intl/intl.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _availableSpaces = [];
  List<Map<String, dynamic>> _registeredVehicles = [];
  int? _selectedSpaceId;
  int? _selectedVehicleId;
  String _searchPlate = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final spaces = await _dbHelper.rawQuery("SELECT * FROM parking_spaces WHERE is_occupied = 0");
    final vehicles = await _dbHelper.queryAll('vehicles');
    setState(() {
      _availableSpaces = spaces;
      _registeredVehicles = vehicles;
    });
  }

  Future<void> _checkIn() async {
    if (_selectedSpaceId == null || _selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select both space and vehicle')));
      return;
    }

    try {
      // Create session
      await _dbHelper.insert('parking_sessions', {
        'vehicle_id': _selectedVehicleId,
        'space_id': _selectedSpaceId,
        'check_in_time': DateTime.now().toIso8601String(),
        'status': 'active',
      });

      // Update space status
      await _dbHelper.update('parking_spaces', {'is_occupied': 1}, 'id = ?', [_selectedSpaceId]);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check-in Successful!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Check In Vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Plate Number...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (value) => setState(() => _searchPlate = value.toUpperCase()),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: _registeredVehicles.where((v) => v['plate_number'].contains(_searchPlate)).length,
                itemBuilder: (context, index) {
                  final vehicle = _registeredVehicles.where((v) => v['plate_number'].contains(_searchPlate)).toList()[index];
                  return Card(
                    color: _selectedVehicleId == vehicle['id'] ? AppColors.secondaryBackground : AppColors.cardBackground,
                    child: ListTile(
                      title: Text(vehicle['plate_number'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${vehicle['vehicle_type']} - ${vehicle['model']}'),
                      trailing: _selectedVehicleId == vehicle['id'] ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                      onTap: () => setState(() => _selectedVehicleId = vehicle['id']),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select Parking Space', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _availableSpaces.length,
                itemBuilder: (context, index) {
                  final space = _availableSpaces[index];
                  return InkWell(
                    onTap: () => setState(() => _selectedSpaceId = space['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedSpaceId == space['id'] ? AppColors.accent : AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(space['space_number'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _checkIn,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Confirm Check-In', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
