import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/service_record.dart';
import '../models/reminder.dart';
import '../models/part.dart';
import '../models/vehicle.dart';
import '../theme.dart';

class AddEditServiceScreen extends StatefulWidget {
  final int vehicleId;
  final ServiceRecord? serviceRecord;
  const AddEditServiceScreen({super.key, required this.vehicleId, this.serviceRecord});

  @override
  State<AddEditServiceScreen> createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends State<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _serviceType;
  late DateTime _date;
  late int _mileage;
  late String _description;
  DateTime? _nextServiceDate;
  int? _nextServiceMileage;
  bool _createReminder = true;
  List<Part> _parts = [];
  final TextEditingController _partNameController = TextEditingController();
  final TextEditingController _partCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serviceType = widget.serviceRecord?.serviceType ?? 'Oil Change';
    _date = widget.serviceRecord?.date ?? DateTime.now();
    _mileage = widget.serviceRecord?.mileage ?? 0;
    _description = widget.serviceRecord?.description ?? '';
    _nextServiceDate = widget.serviceRecord?.nextServiceDate;
    _nextServiceMileage = widget.serviceRecord?.nextServiceMileage;
    if (widget.serviceRecord != null) {
      _loadParts();
    }
  }

  Future<void> _loadParts() async {
    final parts = await DatabaseHelper.instance.readParts(widget.serviceRecord!.id!);
    setState(() {
      _parts = parts;
    });
  }

  double get _totalCost => _parts.fold(0, (sum, part) => sum + part.cost);

  void _addPart() {
    if (_partNameController.text.isNotEmpty && _partCostController.text.isNotEmpty) {
      setState(() {
        _parts.add(Part(
          serviceRecordId: widget.serviceRecord?.id ?? 0,
          name: _partNameController.text,
          cost: double.parse(_partCostController.text),
        ));
      });
      _partNameController.clear();
      _partCostController.clear();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectNextDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextServiceDate ?? DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _nextServiceDate = picked;
      });
    }
  }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = ServiceRecord(
        id: widget.serviceRecord?.id,
        vehicleId: widget.vehicleId,
        serviceType: _serviceType,
        date: _date,
        mileage: _mileage,
        cost: _totalCost,
        description: _description,
        nextServiceDate: _nextServiceDate,
        nextServiceMileage: _nextServiceMileage,
      );

      int recordId;
      if (widget.serviceRecord == null) {
        recordId = await DatabaseHelper.instance.createServiceRecord(record);
        
        // Update vehicle's current mileage
        final vehicle = await DatabaseHelper.instance.readVehicle(widget.vehicleId);
        if (vehicle != null && _mileage > vehicle.currentMileage) {
          final updatedVehicle = Vehicle(
            id: vehicle.id,
            name: vehicle.name,
            make: vehicle.make,
            model: vehicle.model,
            year: vehicle.year,
            licensePlate: vehicle.licensePlate,
            currentMileage: _mileage,
            imageUrl: vehicle.imageUrl,
          );
          await DatabaseHelper.instance.updateVehicle(updatedVehicle);
        }

        // Create reminder if requested
        if (_createReminder && _nextServiceDate != null) {
          await DatabaseHelper.instance.createReminder(Reminder(
            vehicleId: widget.vehicleId,
            title: 'Next $_serviceType',
            dueDate: _nextServiceDate!,
            dueMileage: _nextServiceMileage,
          ));
        }
      } else {
        await DatabaseHelper.instance.updateServiceRecord(record);
        recordId = widget.serviceRecord!.id!;
        await DatabaseHelper.instance.deletePartsForService(recordId);
      }

      // Save parts
      for (var part in _parts) {
        await DatabaseHelper.instance.createPart(Part(
          serviceRecordId: recordId,
          name: part.name,
          cost: part.cost,
        ));
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceRecord == null ? 'Add Service' : 'Edit Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _serviceType,
                decoration: const InputDecoration(labelText: 'Service Type (e.g. Oil Change)'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _serviceType = val!,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${_date.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today, color: AppColors.primary),
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                initialValue: _mileage.toString(),
                decoration: const InputDecoration(labelText: 'Mileage at Service (km)'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Invalid mileage' : null,
                onSaved: (val) => _mileage = int.parse(val!),
              ),
              const SizedBox(height: 24),
              Text('Parts & Costs', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _partNameController,
                      decoration: const InputDecoration(hintText: 'Part Name', isDense: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _partCostController,
                      decoration: const InputDecoration(hintText: 'Cost', isDense: true),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.add_circle, color: AppColors.accent, size: 32),
                    onPressed: _addPart,
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _parts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_parts[index].name),
                    trailing: Text('\$${_parts[index].cost.toStringAsFixed(2)}'),
                    onLongPress: () => setState(() => _parts.removeAt(index)),
                  );
                }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Total Dynamic Cost: \$${_totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 24),
              const Text('Maintenance Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_nextServiceDate == null ? 'Set Next Service Date' : 'Next Date: ${_nextServiceDate!.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.event_repeat, color: AppColors.primary),
                onTap: () => _selectNextDate(context),
              ),
              TextFormField(
                initialValue: _nextServiceMileage?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Next Service Mileage (Optional)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _nextServiceMileage = (val != null && val.isNotEmpty) ? int.parse(val) : null,
              ),
              SwitchListTile(
                title: const Text('Add to Reminders'),
                value: _createReminder,
                onChanged: (val) => setState(() => _createReminder = val),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveService,
                  child: const Text('SAVE RECORD'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
