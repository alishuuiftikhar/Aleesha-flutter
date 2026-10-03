import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';

class AddMaintenanceRecordScreen extends StatefulWidget {
  const AddMaintenanceRecordScreen({super.key});

  @override
  State<AddMaintenanceRecordScreen> createState() => _AddMaintenanceRecordScreenState();
}

class _AddMaintenanceRecordScreenState extends State<AddMaintenanceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _costController = TextEditingController();
  String? _selectedAssetId;
  List<Asset> _assets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final assets = await context.read<SupabaseService>().getAssets();
      setState(() => _assets = assets);
    } catch (e) {}
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedAssetId == null) return;

    setState(() => _isLoading = true);
    try {
      await context.read<SupabaseService>().addMaintenanceRecord(
        _selectedAssetId!,
        _descController.text.trim(),
        double.tryParse(_costController.text) ?? 0.0,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance Record')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedAssetId,
                decoration: const InputDecoration(labelText: 'Select Asset', prefixIcon: Icon(Icons.devices)),
                items: _assets.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (value) => setState(() => _selectedAssetId = value),
                validator: (value) => value == null ? 'Please select an asset' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Enter cost' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SAVE RECORD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
