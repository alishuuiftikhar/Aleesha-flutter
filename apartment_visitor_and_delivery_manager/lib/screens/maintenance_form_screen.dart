import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/maintenance.dart';
import '../theme/app_theme.dart';

class MaintenanceFormScreen extends StatefulWidget {
  final MaintenanceVisit? item;

  const MaintenanceFormScreen({super.key, this.item});

  @override
  State<MaintenanceFormScreen> createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _workerNameController;
  late TextEditingController _apartmentController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _purposeController;
  late TextEditingController _notesController;

  late String _serviceType;
  late DateTime _selectedDate;
  late String _time;
  late String _status;
  bool _isSaving = false;

  final List<String> _serviceTypes = [
    'Plumbing',
    'Electrical',
    'Internet',
    'AC',
    'Cleaning',
    'Repair',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.item;
    _workerNameController = TextEditingController(text: m?.workerName ?? '');
    _apartmentController = TextEditingController(text: m?.apartment ?? 'Apt 402');
    _phoneController = TextEditingController(text: m?.phoneNumber ?? '');
    _companyController = TextEditingController(text: m?.company ?? '');
    _purposeController = TextEditingController(text: m?.purpose ?? '');
    _notesController = TextEditingController(text: m?.notes ?? '');

    _serviceType = m?.serviceType ?? 'Plumbing';
    if (!_serviceTypes.contains(_serviceType)) {
      _serviceTypes.add(_serviceType);
    }

    if (m != null && m.date.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(m.date);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    } else {
      _selectedDate = DateTime.now();
    }

    _time = m?.time ?? '09:00 AM';
    _status = m?.status ?? 'Scheduled';
  }

  @override
  void dispose() {
    _workerNameController.dispose();
    _apartmentController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);
    try {
      final dt = DateFormat('hh:mm a').parse(_time);
      initialTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        _time = DateFormat('hh:mm a').format(dt);
      });
    }
  }

  Future<void> _saveMaintenance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final maintenanceToSave = MaintenanceVisit(
      id: widget.item?.id,
      workerName: _workerNameController.text.trim(),
      serviceType: _serviceType,
      date: dateStr,
      time: _time,
      apartment: _apartmentController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      company: _companyController.text.trim(),
      purpose: _purposeController.text.trim(),
      status: _status,
      notes: _notesController.text.trim(),
      isFavorite: widget.item?.isFavorite ?? false,
    );

    try {
      if (widget.item == null) {
        await DatabaseHelper.instance.insertMaintenance(maintenanceToSave);
      } else {
        await DatabaseHelper.instance.updateMaintenance(maintenanceToSave);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.item == null ? 'Maintenance visit scheduled!' : 'Maintenance record updated!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Maintenance Visit' : 'Schedule Maintenance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Technician & Service Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),

              // Worker Name
              TextFormField(
                controller: _workerNameController,
                decoration: const InputDecoration(
                  labelText: 'Worker / Technician Name *',
                  prefixIcon: Icon(Icons.handyman, color: AppTheme.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter worker name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Service Type Dropdown & Company Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _serviceType,
                      decoration: const InputDecoration(
                        labelText: 'Service Type',
                        prefixIcon: Icon(Icons.build, color: AppTheme.primary),
                      ),
                      items: _serviceTypes.map((st) {
                        return DropdownMenuItem(value: st, child: Text(st));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _serviceType = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company / Agency',
                        prefixIcon: Icon(Icons.business, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Purpose & Apartment Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose / Service Details',
                        prefixIcon: Icon(Icons.description, color: AppTheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController,
                      decoration: const InputDecoration(
                        labelText: 'Apartment Unit',
                        prefixIcon: Icon(Icons.home, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Technician Phone',
                  prefixIcon: Icon(Icons.phone, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Date & Time Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, color: AppTheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Appointment Date', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(DateFormat('MMM d, yyyy').format(_selectedDate),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
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
                      onTap: _pickTime,
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
                                const Text('Appointment Time', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(_time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
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

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Visit Status',
                  prefixIcon: Icon(Icons.rule, color: AppTheme.primary),
                ),
                items: const [
                  DropdownMenuItem(value: 'Scheduled', child: Text('Scheduled')),
                  DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                  DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
              ),
              const SizedBox(height: 14),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
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
                  onPressed: _isSaving ? null : _saveMaintenance,
                  icon: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Update Visit Record' : 'Schedule Maintenance Visit',
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
