import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/repair_provider.dart';
import '../models/customer.dart';
import '../models/device.dart';
import '../models/repair_order.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';

class AddRepairScreen extends StatefulWidget {
  const AddRepairScreen({super.key});

  @override
  State<AddRepairScreen> createState() => _AddRepairScreenState();
}

class _AddRepairScreenState extends State<AddRepairScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Customer
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Device
  final _deviceTypeController = TextEditingController();
  final _deviceModelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  
  // Repair
  final _problemController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  
  int? _selectedTechnicianId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepairProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('New Repair Order')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Customer Information'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Device Details'),
            TextFormField(
              controller: _deviceTypeController,
              decoration: const InputDecoration(labelText: 'Device Type (e.g., Phone, Laptop)'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _deviceModelController,
              decoration: const InputDecoration(labelText: 'Device Model'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(labelText: 'Serial Number'),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Repair Information'),
            TextFormField(
              controller: _problemController,
              decoration: const InputDecoration(labelText: 'Problem Description'),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _estimatedCostController,
              decoration: const InputDecoration(labelText: 'Estimated Cost (\$)'),
              keyboardType: TextInputType.number,
              validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Invalid cost' : null,
            ),
            DropdownButtonFormField<int>(
              value: _selectedTechnicianId,
              decoration: const InputDecoration(labelText: 'Assign Technician'),
              items: provider.technicians.map((t) => DropdownMenuItem(
                value: t.id,
                child: Text(t.name),
              )).toList(),
              onChanged: (val) => setState(() => _selectedTechnicianId = val),
              validator: (v) => v == null ? 'Required' : null,
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveRepair,
              child: const Text('Save Repair Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        const Divider(),
      ],
    );
  }

  Future<void> _saveRepair() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;
      
      // 1. Save Customer
      final customerId = await db.insert('customers', {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': '',
        'address': '',
      });

      // 2. Save Device
      final deviceId = await db.insert('devices', {
        'customer_id': customerId,
        'type': _deviceTypeController.text,
        'model': _deviceModelController.text,
        'serial_number': _serialNumberController.text,
      });

      // 3. Save Repair Order
      final order = RepairOrder(
        deviceId: deviceId,
        technicianId: _selectedTechnicianId!,
        problemDescription: _problemController.text,
        status: RepairStatus.Received,
        estimatedCost: double.parse(_estimatedCostController.text),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await db.insert('repair_orders', order.toMap());
      
      if (mounted) {
        Provider.of<RepairProvider>(context, listen: false).fetchAllData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Repair order created successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }
}
