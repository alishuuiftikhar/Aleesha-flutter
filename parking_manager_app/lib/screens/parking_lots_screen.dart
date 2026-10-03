import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';

class ParkingLotsScreen extends StatefulWidget {
  const ParkingLotsScreen({super.key});

  @override
  State<ParkingLotsScreen> createState() => _ParkingLotsScreenState();
}

class _ParkingLotsScreenState extends State<ParkingLotsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _spaces = [];

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  Future<void> _loadSpaces() async {
    final data = await _dbHelper.queryAll('parking_spaces');
    setState(() {
      _spaces = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Parking Grid', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.secondaryBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Available', AppColors.secondary),
                _buildLegendItem('Occupied', Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: _spaces.length,
              itemBuilder: (context, index) {
                final space = _spaces[index];
                final bool isOccupied = space['is_occupied'] == 1;
                return Container(
                  decoration: BoxDecoration(
                    color: isOccupied ? Colors.redAccent.withOpacity(0.8) : AppColors.secondary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isOccupied ? Icons.directions_car : Icons.local_parking, color: Colors.white, size: 30),
                      const SizedBox(height: 5),
                      Text(space['space_number'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(space['vehicle_type'], style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 15, height: 15, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
      ],
    );
  }
}
