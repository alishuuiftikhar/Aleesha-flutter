import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ReportFormScreen extends StatefulWidget {
  final LostFoundItem? initialItem;

  const ReportFormScreen({super.key, this.initialItem});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _identifyingDetailsController;
  
  ItemCategory _category = ItemCategory.electronics;
  ReportType _type = ReportType.lost;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  XFile? _imageFile;
  String? _existingImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _locationController = TextEditingController(text: widget.initialItem?.location ?? '');
    _descriptionController = TextEditingController(text: widget.initialItem?.description ?? '');
    _identifyingDetailsController = TextEditingController(text: widget.initialItem?.identifyingDetails ?? '');
    
    if (widget.initialItem != null) {
      _category = widget.initialItem!.category;
      _type = widget.initialItem!.type;
      _selectedDate = widget.initialItem!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.initialItem!.dateTime);
      _existingImagePath = widget.initialItem!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final provider = Provider.of<AppProvider>(context, listen: false);
        
        final dateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final item = LostFoundItem(
          id: widget.initialItem?.id ?? const Uuid().v4(),
          name: _nameController.text,
          category: _category,
          type: _type,
          location: _locationController.text,
          dateTime: dateTime,
          description: _descriptionController.text,
          identifyingDetails: _identifyingDetailsController.text,
          imagePath: _imageFile?.path ?? _existingImagePath,
          reporterId: provider.currentUserId,
          status: widget.initialItem?.status ?? ItemStatus.reported,
        );

        if (widget.initialItem == null) {
          await provider.addItem(item);
        } else {
          await provider.updateItem(item);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.initialItem == null ? 'Report submitted successfully!' : 'Report updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving report: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialItem == null ? 'New Report' : 'Edit Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 24),
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildTextField('Item Name', _nameController, 'Enter item name'),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildTextField('Location', _locationController, 'Where was it lost/found?'),
              const SizedBox(height: 16),
              _buildDateTimePickers(),
              const SizedBox(height: 16),
              _buildTextField('Description', _descriptionController, 'General description', maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField('Identifying Details', _identifyingDetailsController, 'Details only the owner would know', maxLines: 2),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.initialItem == null ? 'Submit Report' : 'Save Changes'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Center(child: Text('LOST')),
            selected: _type == ReportType.lost,
            onSelected: (val) => setState(() => _type = ReportType.lost),
            selectedColor: AppColors.error.withOpacity(0.2),
            labelStyle: TextStyle(color: _type == ReportType.lost ? AppColors.error : AppColors.text, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ChoiceChip(
            label: const Center(child: Text('FOUND')),
            selected: _type == ReportType.found,
            onSelected: (val) => setState(() => _type = ReportType.found),
            selectedColor: AppColors.success.withOpacity(0.2),
            labelStyle: TextStyle(color: _type == ReportType.found ? AppColors.success : AppColors.text, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary.withOpacity(0.5), width: 1),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                    : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
              )
            : (_existingImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (_existingImagePath!.startsWith('http') || kIsWeb)
                        ? Image.network(_existingImagePath!, fit: BoxFit.cover)
                        : Image.file(File(_existingImagePath!), fit: BoxFit.cover),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.secondary),
                      SizedBox(height: 8),
                      Text('Add Item Image', style: TextStyle(color: AppColors.secondary)),
                    ],
                  )),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
          validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<ItemCategory>(
          value: _category,
          items: ItemCategory.values.map((cat) {
            return DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase()));
          }).toList(),
          onChanged: (val) => setState(() => _category = val!),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }

  Widget _buildDateTimePickers() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) setState(() => _selectedTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text(_selectedTime.format(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
