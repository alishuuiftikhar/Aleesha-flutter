import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _organizerController = TextEditingController();
  
  String _selectedCategory = 'Music';
  final List<String> _categories = ['Music', 'Technology', 'Food', 'Art', 'Sports', 'Party'];
  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final newEvent = Event(
      id: 'EV${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descController.text,
      location: _locationController.text,
      address: _addressController.text,
      date: DateTime.now().add(const Duration(days: 7)), // Mock date for now
      time: '06:00 PM - 09:00 PM',
      imageUrl: 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800&q=80', // Mock image
      price: double.tryParse(_priceController.text) ?? 0.0,
      category: _selectedCategory,
      organizer: _organizerController.text,
      organizerImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80',
    );

    try {
      await context.read<EventProvider>().addEvent(newEvent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!'), backgroundColor: AppTheme.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection(),
              const SizedBox(height: 32),
              
              _buildLabel('Event Title'),
              _buildTextField('e.g. Neon Summer Festival', Icons.title, controller: _titleController),
              const SizedBox(height: 20),

              _buildLabel('Category'),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),

              _buildLabel('Description'),
              _buildTextField('Tell us about the event in detail...', Icons.description, maxLines: 4, controller: _descController),
              const SizedBox(height: 20),

              _buildLabel('Venue & Address'),
              _buildTextField('Where will it happen?', Icons.location_on, controller: _addressController),
              const SizedBox(height: 20),
              
              _buildLabel('City / Location'),
              _buildTextField('e.g. New York, NY', Icons.map, controller: _locationController),
              const SizedBox(height: 20),

              _buildLabel('Base Ticket Price (\$)'),
              _buildTextField('e.g. 49.99', Icons.attach_money, controller: _priceController),
              const SizedBox(height: 20),

              _buildLabel('Organizer Name'),
              _buildTextField('e.g. Vibe Nation Events', Icons.person, controller: _organizerController),
              const SizedBox(height: 40),

              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Create Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withAlpha(10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withAlpha(40), style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_rounded, size: 48, color: AppTheme.primaryColor),
          SizedBox(height: 12),
          Text(
            'Upload Event Cover Image',
            style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Best size: 1200 x 800 px',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText, fontSize: 15),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.secondaryText, fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withAlpha(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withAlpha(10)),
        ),
      ),
      validator: (val) => val!.isEmpty ? 'This field is required' : null,
    );
  }
}
