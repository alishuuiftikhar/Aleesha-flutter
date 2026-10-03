import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/visitor.dart';
import '../theme/app_theme.dart';

class VisitorFormScreen extends StatefulWidget {
  final Visitor? visitor;

  const VisitorFormScreen({super.key, this.visitor});

  @override
  State<VisitorFormScreen> createState() => _VisitorFormScreenState();
}

class _VisitorFormScreenState extends State<VisitorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _purposeController;
  late TextEditingController _apartmentController;
  late TextEditingController _peopleController;
  late TextEditingController _vehicleController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late String _arrivalTime;
  late String _departureTime;
  late String _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final v = widget.visitor;
    _nameController = TextEditingController(text: v?.name ?? '');
    _phoneController = TextEditingController(text: v?.phone ?? '');
    _purposeController = TextEditingController(text: v?.purpose ?? '');
    _apartmentController = TextEditingController(text: v?.apartment ?? 'Apt 402');
    _peopleController = TextEditingController(text: (v?.numberOfPeople ?? 1).toString());
    _vehicleController = TextEditingController(text: v?.vehicleNumber ?? '');
    _notesController = TextEditingController(text: v?.notes ?? '');

    if (v != null && v.visitDate.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(v.visitDate);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    } else {
      _selectedDate = DateTime.now();
    }

    _arrivalTime = v?.expectedArrivalTime ?? '10:00 AM';
    _departureTime = v?.expectedDepartureTime ?? '12:00 PM';
    _status = v?.status ?? 'Expected';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _apartmentController.dispose();
    _peopleController.dispose();
    _vehicleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isArrival) async {
    final initial = isArrival ? _arrivalTime : _departureTime;
    TimeOfDay initialTimeOfDay = const TimeOfDay(hour: 10, minute: 0);
    try {
      final dt = DateFormat('hh:mm a').parse(initial);
      initialTimeOfDay = TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTimeOfDay,
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formatted = DateFormat('hh:mm a').format(dt);
      setState(() {
        if (isArrival) {
          _arrivalTime = formatted;
        } else {
          _departureTime = formatted;
        }
      });
    }
  }

  Future<void> _saveVisitor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final count = int.tryParse(_peopleController.text.trim()) ?? 1;

    final visitorToSave = Visitor(
      id: widget.visitor?.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      purpose: _purposeController.text.trim(),
      visitDate: dateStr,
      expectedArrivalTime: _arrivalTime,
      expectedDepartureTime: _departureTime,
      apartment: _apartmentController.text.trim(),
      numberOfPeople: count,
      vehicleNumber: _vehicleController.text.trim(),
      notes: _notesController.text.trim(),
      status: _status,
      isFavorite: widget.visitor?.isFavorite ?? false,
    );

    try {
      if (widget.visitor == null) {
        await DatabaseHelper.instance.insertVisitor(visitorToSave);
      } else {
        await DatabaseHelper.instance.updateVisitor(visitorToSave);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.visitor == null ? 'Visitor added successfully!' : 'Visitor updated!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving visitor: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.visitor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Visitor' : 'Add New Visitor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visitor Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Visitor Full Name *',
                  prefixIcon: Icon(Icons.person, color: AppTheme.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter visitor name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Purpose & Apartment Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose of Visit',
                        prefixIcon: Icon(Icons.assignment_ind, color: AppTheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController,
                      decoration: const InputDecoration(
                        labelText: 'Apartment / Unit',
                        prefixIcon: Icon(Icons.home, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date Picker Card
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Visit Date', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, size: 18, color: AppTheme.accent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Time Selection Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: AppTheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Expected Arrival', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(_arrivalTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_filled, color: AppTheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Expected Departure', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(_departureTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // People & Vehicle Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _peopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'No. of People',
                        prefixIcon: Icon(Icons.groups, color: AppTheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _vehicleController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Plate No.',
                        prefixIcon: Icon(Icons.directions_car, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.rule, color: AppTheme.primary),
                ),
                items: const [
                  DropdownMenuItem(value: 'Expected', child: Text('Expected')),
                  DropdownMenuItem(value: 'Arrived', child: Text('Arrived')),
                  DropdownMenuItem(value: 'Departed', child: Text('Departed')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
              ),
              const SizedBox(height: 14),

              // Notes Field
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  prefixIcon: Icon(Icons.note_alt_outlined, color: AppTheme.primary),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveVisitor,
                  icon: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Update Visitor Record' : 'Save Visitor Record',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
