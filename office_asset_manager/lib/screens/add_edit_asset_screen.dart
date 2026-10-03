import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';

class AddEditAssetScreen extends StatefulWidget {
  final Asset? asset;
  const AddEditAssetScreen({super.key, this.asset});

  @override
  State<AddEditAssetScreen> createState() => _AddEditAssetScreenState();
}

class _AddEditAssetScreenState extends State<AddEditAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _snController;
  late DateTime _purchaseDate;
  String _condition = 'New';
  String? _categoryId;
  List<AssetCategory> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.asset?.name);
    _snController = TextEditingController(text: widget.asset?.serialNumber);
    _purchaseDate = widget.asset?.purchaseDate ?? DateTime.now();
    _condition = widget.asset?.condition ?? 'New';
    _categoryId = widget.asset?.categoryId;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await context.read<SupabaseService>().getCategories();
      setState(() => _categories = cats);
      if (_categoryId == null && _categories.isNotEmpty) {
        _categoryId = _categories.first.id;
      }
    } catch (e) {}
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabaseService = context.read<SupabaseService>();
      if (widget.asset == null) {
        final newAsset = Asset(
          id: '',
          name: _nameController.text.trim(),
          serialNumber: _snController.text.trim(),
          categoryId: _categoryId!,
          condition: _condition,
          purchaseDate: _purchaseDate,
          status: 'Available',
        );
        await supabaseService.addAsset(newAsset);
      } else {
        await supabaseService.updateAsset(widget.asset!.id, {
          'name': _nameController.text.trim(),
          'serial_number': _snController.text.trim(),
          'category_id': _categoryId,
          'condition': _condition,
          'purchase_date': _purchaseDate.toIso8601String(),
        });
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.asset != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Asset' : 'Add New Asset')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Asset Name', prefixIcon: Icon(Icons.devices)),
                validator: (value) => value?.isEmpty ?? true ? 'Enter asset name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _snController,
                decoration: const InputDecoration(labelText: 'Serial Number', prefixIcon: Icon(Icons.numbers)),
                validator: (value) => value?.isEmpty ?? true ? 'Enter serial number' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _condition,
                decoration: const InputDecoration(labelText: 'Condition', prefixIcon: Icon(Icons.info_outline)),
                items: ['New', 'Good', 'Fair', 'Poor']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _condition = value!),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Purchase Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_purchaseDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _purchaseDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _purchaseDate = picked);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'UPDATE ASSET' : 'ADD ASSET'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
