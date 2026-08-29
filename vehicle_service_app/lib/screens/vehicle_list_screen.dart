import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vehicle.dart';
import 'add_edit_vehicle_screen.dart';
import 'vehicle_detail_screen.dart';
import '../theme.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> _vehicles = [];
  List<Vehicle> _filteredVehicles = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshVehicles();
  }

  Future<void> _refreshVehicles() async {
    setState(() => _isLoading = true);
    _vehicles = await DatabaseHelper.instance.readAllVehicles();
    _filterVehicles(_searchController.text);
    setState(() => _isLoading = false);
  }

  void _filterVehicles(String query) {
    setState(() {
      _filteredVehicles = _vehicles.where((v) {
        final nameLower = v.name.toLowerCase();
        final makeLower = v.make.toLowerCase();
        final modelLower = v.model.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            makeLower.contains(searchLower) ||
            modelLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search vehicles...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              filled: true,
              fillColor: AppColors.cardBackground,
            ),
            onChanged: _filterVehicles,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredVehicles.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _filteredVehicles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(vehicle.imageUrl ?? 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=500&q=80'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${vehicle.make} ${vehicle.model} (${vehicle.year})'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VehicleDetailScreen(vehicle: vehicle)),
                        ).then((_) => _refreshVehicles()),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddEditVehicleScreen()),
        ).then((_) => _refreshVehicles()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No vehicles found', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditVehicleScreen()),
            ).then((_) => _refreshVehicles()),
            child: const Text('Add Your First Vehicle'),
          ),
        ],
      ),
    );
  }
}
