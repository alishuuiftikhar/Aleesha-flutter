import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/car_service.dart';
import '../../theme/app_colors.dart';

class AddEditCarScreen extends StatefulWidget {
  final Map<String, dynamic>? car;

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  late TextEditingController _typeController;
  late TextEditingController _seatsController;
  late TextEditingController _transmissionController;
  late TextEditingController _fuelTypeController;

  bool _availability = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.car?['name']);
    _brandController = TextEditingController(text: widget.car?['brand']);
    _priceController = TextEditingController(text: widget.car?['price_per_day']?.toString());
    _imageUrlController = TextEditingController(text: widget.car?['image_url']);
    _descriptionController = TextEditingController(text: widget.car?['description']);
    _typeController = TextEditingController(text: widget.car?['type'] ?? 'Sedan');
    _seatsController = TextEditingController(text: widget.car?['seats']?.toString() ?? '4');
    _transmissionController = TextEditingController(text: widget.car?['transmission'] ?? 'Auto');
    _fuelTypeController = TextEditingController(text: widget.car?['fuel_type'] ?? 'Petrol');
    _availability = widget.car?['availability'] ?? true;
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final carData = {
        'name': _nameController.text,
        'brand': _brandController.text,
        'price_per_day': int.parse(_priceController.text),
        'image_url': _imageUrlController.text,
        'description': _descriptionController.text,
        'type': _typeController.text,
        'seats': int.parse(_seatsController.text),
        'transmission': _transmissionController.text,
        'fuel_type': _fuelTypeController.text,
        'availability': _availability,
      };

      final carService = Provider.of<CarService>(context, listen: false);
      if (widget.car == null) {
        await carService.addCar(carData);
      } else {
        await carService.updateCar(widget.car!['id'], carData);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.car == null ? 'Add Car' : 'Edit Car')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Car Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _brandController, decoration: const InputDecoration(labelText: 'Brand'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price per Day'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
              const SizedBox(height: 16),
              TextFormField(controller: _typeController, decoration: const InputDecoration(labelText: 'Type (Sedan, SUV, etc.)')),
              const SizedBox(height: 16),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                value: _availability,
                onChanged: (v) => setState(() => _availability = v),
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('SAVE CAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
