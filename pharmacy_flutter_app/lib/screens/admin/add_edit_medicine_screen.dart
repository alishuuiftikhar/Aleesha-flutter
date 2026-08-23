import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine.dart';
import '../../providers/app_provider.dart';
import '../../services/supabase_service.dart';
import '../../utils/theme.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicine;
  const AddEditMedicineScreen({super.key, this.medicine});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageController;
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name);
    _descController = TextEditingController(text: widget.medicine?.description);
    _priceController = TextEditingController(text: widget.medicine?.price.toString());
    _stockController = TextEditingController(text: widget.medicine?.stock.toString());
    _imageController = TextEditingController(text: widget.medicine?.imageUrl);
    _selectedCategoryId = widget.medicine?.categoryId;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final medicineData = {
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'category_id': _selectedCategoryId,
        'image_url': _imageController.text.isNotEmpty ? _imageController.text : null,
      };

      if (widget.medicine == null) {
        await SupabaseService().addMedicine(Medicine(
          id: '',
          name: medicineData['name'] as String,
          description: medicineData['description'] as String,
          price: medicineData['price'] as double,
          stock: medicineData['stock'] as int,
          categoryId: medicineData['category_id'] as String,
          imageUrl: medicineData['image_url'] as String?,
          createdAt: DateTime.now(),
        ));
      } else {
        await SupabaseService().updateMedicine(widget.medicine!.id, medicineData);
      }

      if (mounted) {
        await Provider.of<AppProvider>(context, listen: false).fetchMedicines();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.medicine == null ? 'Add Medicine' : 'Edit Medicine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: provider.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
