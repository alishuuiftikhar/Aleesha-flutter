import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vehicle.dart';
import '../models/service_record.dart';
import '../theme.dart';
import 'add_edit_service_screen.dart';
import 'add_edit_vehicle_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late Vehicle _vehicle;
  List<ServiceRecord> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle;
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    final updatedVehicle = await DatabaseHelper.instance.readVehicle(_vehicle.id!);
    if (updatedVehicle != null) {
      _vehicle = updatedVehicle;
    }
    _services = await DatabaseHelper.instance.readServiceRecords(_vehicle.id!);
    setState(() => _isLoading = false);
  }

  Future<void> _deleteVehicle() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Are you sure you want to delete this vehicle and all its records?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteVehicle(_vehicle.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_vehicle.name),
                    background: Image.network(
                      _vehicle.imageUrl ?? 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=500&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddEditVehicleScreen(vehicle: _vehicle)),
                      ).then((_) => _refreshData()),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteVehicle,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Service History', style: Theme.of(context).textTheme.titleLarge),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddEditServiceScreen(vehicleId: _vehicle.id!)),
                              ).then((_) => _refreshData()),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Service'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _services.isEmpty
                            ? const Center(child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text('No service records yet.'),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _services.length,
                                itemBuilder: (context, index) {
                                  final service = _services[index];
                                  return _buildServiceCard(service);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.branding_watermark, 'Make & Model', '${_vehicle.make} ${_vehicle.model}'),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Year', _vehicle.year.toString()),
            const Divider(),
            _buildInfoRow(Icons.badge, 'License Plate', _vehicle.licensePlate),
            const Divider(),
            _buildInfoRow(Icons.speed, 'Current Mileage', '${_vehicle.currentMileage} km'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceRecord service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(service.serviceType, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${service.date.toString().split(' ')[0]} | ${service.mileage} km'),
        trailing: Text('\$${service.cost.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Text(service.description),
                if (service.nextServiceDate != null) ...[
                  const SizedBox(height: 8),
                  Text('Next Service:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                  Text('${service.nextServiceDate!.toString().split(' ')[0]} or ${service.nextServiceMileage} km'),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteServiceRecord(service.id!);
                        _refreshData();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
