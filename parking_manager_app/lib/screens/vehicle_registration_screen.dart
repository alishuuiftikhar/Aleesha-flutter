import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedType = 'Car';
  final DBHelper _dbHelper = DBHelper();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // First create customer
        final customerId = await _dbHelper.insert('customers', {
          'name': _ownerController.text,
          'phone': _phoneController.text,
        });

        // Then create vehicle
        await _dbHelper.insert('vehicles', {
          'customer_id': customerId,
          'plate_number': _plateController.text.toUpperCase(),
          'vehicle_type': _selectedType,
          'model': _modelController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle Registered Successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Register Vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vehicle Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildTextField(_plateController, 'Plate Number (e.g. ABC-1234)', Icons.pin),
              const SizedBox(height: 15),
              _buildDropdown(),
              const SizedBox(height: 15),
              _buildTextField(_modelController, 'Model / Brand', Icons.directions_car),
              const SizedBox(height: 30),
              const Text('Owner Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildTextField(_ownerController, 'Full Name', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Register Vehicle', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.secondary),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? 'Field required' : null,
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: const InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.category, color: AppColors.secondary)),
        items: ['Car', 'Bike', 'Truck', 'Van'].map((String type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList(),
        onChanged: (value) => setState(() => _selectedType = value!),
      ),
    );
  }
}
