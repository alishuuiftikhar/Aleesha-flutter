import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';
import 'add_maintenance_record_screen.dart';

class MaintenanceRecordsScreen extends StatefulWidget {
  const MaintenanceRecordsScreen({super.key});

  @override
  State<MaintenanceRecordsScreen> createState() => _MaintenanceRecordsScreenState();
}

class _MaintenanceRecordsScreenState extends State<MaintenanceRecordsScreen> {
  List<MaintenanceRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    try {
      final records = await context.read<SupabaseService>().getMaintenanceRecords();
      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Records')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(child: Text('No maintenance records found'))
              : RefreshIndicator(
                  onRefresh: _loadRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.secondaryBackground,
                            child: Icon(Icons.build, color: AppColors.primary),
                          ),
                          title: Text(record.assetName ?? 'Unknown Asset', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(record.description),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy').format(record.date),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '\$${record.cost.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMaintenanceRecordScreen()),
          );
          if (result == true) _loadRecords();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
