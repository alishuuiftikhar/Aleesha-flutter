import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/delivery.dart';
import '../theme/app_theme.dart';

class DeliveryFormScreen extends StatefulWidget {
  final Delivery? delivery;

  const DeliveryFormScreen({super.key, this.delivery});

  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyController;
  late TextEditingController _trackingController;
  late TextEditingController _descriptionController;
  late TextEditingController _personNameController;
  late TextEditingController _personPhoneController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late String _arrivalTime;
  late String _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.delivery;
    _companyController = TextEditingController(text: d?.deliveryCompany ?? '');
    _trackingController = TextEditingController(text: d?.trackingNumber ?? '');
    _descriptionController = TextEditingController(text: d?.packageDescription ?? '');
    _personNameController = TextEditingController(text: d?.deliveryPersonName ?? '');
    _personPhoneController = TextEditingController(text: d?.deliveryPersonPhone ?? '');
    _notesController = TextEditingController(text: d?.notes ?? '');

    if (d != null && d.arrivalDate.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(d.arrivalDate);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    } else {
      _selectedDate = DateTime.now();
    }

    _arrivalTime = d?.arrivalTime ?? '12:00 PM';
    _status = d?.status ?? 'Expected';
  }

  @override
  void dispose() {
    _companyController.dispose();
    _trackingController.dispose();
    _descriptionController.dispose();
    _personNameController.dispose();
    _personPhoneController.dispose();
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
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay initialTime = const TimeOfDay(hour: 12, minute: 0);
    try {
      final dt = DateFormat('hh:mm a').parse(_arrivalTime);
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
        _arrivalTime = DateFormat('hh:mm a').format(dt);
      });
    }
  }

  Future<void> _saveDelivery() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final deliveryToSave = Delivery(
      id: widget.delivery?.id,
      deliveryCompany: _companyController.text.trim(),
      trackingNumber: _trackingController.text.trim(),
      packageDescription: _descriptionController.text.trim(),
      arrivalDate: dateStr,
      arrivalTime: _arrivalTime,
      deliveryPersonName: _personNameController.text.trim(),
      deliveryPersonPhone: _personPhoneController.text.trim(),
      status: _status,
      notes: _notesController.text.trim(),
      isFavorite: widget.delivery?.isFavorite ?? false,
    );

    try {
      if (widget.delivery == null) {
        await DatabaseHelper.instance.insertDelivery(deliveryToSave);
      } else {
        await DatabaseHelper.instance.updateDelivery(deliveryToSave);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.delivery == null ? 'Delivery added!' : 'Delivery record updated!'),
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
    final isEditing = widget.delivery != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Delivery' : 'Add Delivery Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Package & Carrier Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),

              // Delivery Company
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Company / Courier *',
                  prefixIcon: Icon(Icons.local_shipping, color: AppTheme.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter delivery company (e.g., FedEx, Amazon, DHL)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Tracking Number
              TextFormField(
                controller: _trackingController,
                decoration: const InputDecoration(
                  labelText: 'Tracking / Order Number',
                  prefixIcon: Icon(Icons.qr_code, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Package Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Package Description',
                  prefixIcon: Icon(Icons.inventory_2_outlined, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 14),

              // Date & Time Selectors Row
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
                                const Text('Arrival Date', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
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
                                const Text('Arrival Time', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(_arrivalTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
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

              // Courier Person Name & Phone Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _personNameController,
                      decoration: const InputDecoration(
                        labelText: 'Courier Person',
                        prefixIcon: Icon(Icons.person, color: AppTheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _personPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Courier Phone',
                        prefixIcon: Icon(Icons.phone, color: AppTheme.primary),
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
                  labelText: 'Delivery Status',
                  prefixIcon: Icon(Icons.rule, color: AppTheme.primary),
                ),
                items: const [
                  DropdownMenuItem(value: 'Expected', child: Text('Expected')),
                  DropdownMenuItem(value: 'Received', child: Text('Received (At Gate/Lobby)')),
                  DropdownMenuItem(value: 'Collected', child: Text('Collected by Resident')),
                  DropdownMenuItem(value: 'Returned', child: Text('Returned')),
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

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveDelivery,
                  icon: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Update Delivery' : 'Save Delivery Record',
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
