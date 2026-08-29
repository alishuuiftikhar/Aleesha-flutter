import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../services/supabase_service.dart';
import '../../models/event.dart';
import '../../models/category.dart';

class CreateEventScreen extends StatefulWidget {
  final String organizerId;
  final Event? event;

  const CreateEventScreen({super.key, required this.organizerId, this.event});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _capacityController;
  late TextEditingController _imageUrlController;
  
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;
  List<EventCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title);
    _descController = TextEditingController(text: widget.event?.description);
    _locationController = TextEditingController(text: widget.event?.location);
    _priceController = TextEditingController(text: widget.event?.price.toString());
    _capacityController = TextEditingController(text: widget.event?.capacity.toString());
    _imageUrlController = TextEditingController(text: widget.event?.imageUrl);
    _selectedCategoryId = widget.event?.categoryId;
    if (widget.event != null) _selectedDate = widget.event!.dateTime;
    
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await Provider.of<SupabaseService>(context, listen: false).getCategories();
    setState(() {
      _categories = categories;
      if (_selectedCategoryId == null && categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
      }
    });
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      
      final event = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        dateTime: _selectedDate,
        location: _locationController.text,
        imageUrl: _imageUrlController.text,
        gallery: widget.event?.gallery ?? [],
        price: double.parse(_priceController.text),
        capacity: int.parse(_capacityController.text),
        remainingCapacity: widget.event != null 
            ? widget.event!.remainingCapacity + (int.parse(_capacityController.text) - widget.event!.capacity)
            : int.parse(_capacityController.text),
        categoryId: _selectedCategoryId!,
        organizerId: widget.organizerId,
      );

      if (widget.event == null) {
        await supabaseService.createEvent(event);
      } else {
        await supabaseService.updateEvent(event);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event == null ? 'Create Event' : 'Edit Event')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Event Title'),
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
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Price (\$)'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _capacityController,
                            decoration: const InputDecoration(labelText: 'Capacity'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      title: const Text('Event Date & Time'),
                      subtitle: Text(_selectedDate.toString()),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedDate),
                          );
                          if (time != null) {
                            setState(() {
                              _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _saveEvent,
                      child: Text(widget.event == null ? 'Create Event' : 'Update Event'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
