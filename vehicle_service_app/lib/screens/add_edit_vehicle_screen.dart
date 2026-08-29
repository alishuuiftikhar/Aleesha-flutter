import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vehicle.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;
  const AddEditVehicleScreen({super.key, this.vehicle});

  @override
  State<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _make;
  late String _model;
  late int _year;
  late String _licensePlate;
  late int _currentMileage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.vehicle?.name ?? '';
    _make = widget.vehicle?.make ?? '';
    _model = widget.vehicle?.model ?? '';
    _year = widget.vehicle?.year ?? DateTime.now().year;
    _licensePlate = widget.vehicle?.licensePlate ?? '';
    _currentMileage = widget.vehicle?.currentMileage ?? 0;
    _imageUrl = widget.vehicle?.imageUrl;
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final vehicle = Vehicle(
        id: widget.vehicle?.id,
        name: _name,
        make: _make,
        model: _model,
        year: _year,
        licensePlate: _licensePlate,
        currentMileage: _currentMileage,
        imageUrl: _imageUrl ?? 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=500&q=80',
      );

      if (widget.vehicle == null) {
        await DatabaseHelper.instance.createVehicle(vehicle);
      } else {
        await DatabaseHelper.instance.updateVehicle(vehicle);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Vehicle Nickname (e.g. My Mustang)'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _make,
                      decoration: const InputDecoration(labelText: 'Make'),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => _make = val!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _model,
                      decoration: const InputDecoration(labelText: 'Model'),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => _model = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _year.toString(),
                      decoration: const InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Invalid year' : null,
                      onSaved: (val) => _year = int.parse(val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _licensePlate,
                      decoration: const InputDecoration(labelText: 'License Plate'),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => _licensePlate = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _currentMileage.toString(),
                decoration: const InputDecoration(labelText: 'Current Mileage'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Invalid mileage' : null,
                onSaved: (val) => _currentMileage = int.parse(val!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVehicle,
                  child: const Text('SAVE VEHICLE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
