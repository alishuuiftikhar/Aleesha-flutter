import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/internship_model.dart';
import '../models/company_model.dart';
import '../models/supervisor_model.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';

class AddEditInternshipScreen extends StatefulWidget {
  final Internship? internship;

  const AddEditInternshipScreen({super.key, this.internship});

  @override
  State<AddEditInternshipScreen> createState() => _AddEditInternshipScreenState();
}

class _AddEditInternshipScreenState extends State<AddEditInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Company & Supervisor logic
  Company? _selectedCompany;
  Supervisor? _selectedSupervisor;
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));
  String _status = 'Planned';
  
  final List<String> _statusOptions = ['Planned', 'Ongoing', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    if (widget.internship != null) {
      final i = widget.internship!;
      _positionController.text = i.position;
      _departmentController.text = i.department;
      _durationController.text = i.duration;
      _descriptionController.text = i.description ?? '';
      _startDate = i.startDate;
      _endDate = i.endDate;
      _status = i.status;
      
      // We'll set the company and supervisor in build or after provider loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<AppProvider>(context, listen: false);
        setState(() {
          _selectedCompany = provider.getCompanyById(i.companyId);
          if (i.supervisorId != null) {
            _selectedSupervisor = provider.getSupervisorById(i.supervisorId!);
          }
        });
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.secondaryBackground,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCompany == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select or add a company')),
        );
        return;
      }

      final provider = Provider.of<AppProvider>(context, listen: false);
      final internship = Internship(
        id: widget.internship?.id,
        companyId: _selectedCompany!.id!,
        supervisorId: _selectedSupervisor?.id,
        position: _positionController.text,
        department: _departmentController.text,
        startDate: _startDate,
        endDate: _endDate,
        duration: _durationController.text,
        status: _status,
        description: _descriptionController.text,
      );

      if (widget.internship == null) {
        provider.addInternship(internship);
      } else {
        provider.updateInternship(internship);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.internship == null ? 'Add Internship' : 'Edit Internship'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Company Information'),
              _buildCompanyPicker(),
              const SizedBox(height: 24),
              _buildSectionTitle('Supervisor Information'),
              _buildSupervisorPicker(),
              const SizedBox(height: 24),
              _buildSectionTitle('Internship Details'),
              _buildTextField(_positionController, 'Position', Icons.work, 'e.g. Flutter Developer'),
              _buildTextField(_departmentController, 'Department', Icons.business, 'e.g. Engineering'),
              _buildTextField(_durationController, 'Duration', Icons.timer, 'e.g. 3 Months'),
              _buildTextField(_descriptionController, 'Description', Icons.description, 'Optional', maxLines: 3),
              const SizedBox(height: 24),
              _buildSectionTitle('Status & Dates'),
              _buildStatusPicker(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDatePicker('Start Date', _startDate, true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('End Date', _endDate, false)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Internship',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.secondaryText),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
      ),
    );
  }

  Widget _buildCompanyPicker() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            DropdownButtonFormField<Company>(
              value: _selectedCompany,
              decoration: const InputDecoration(
                labelText: 'Select Company',
                prefixIcon: Icon(Icons.location_city, color: AppColors.secondaryText),
              ),
              items: provider.companies.map((c) {
                return DropdownMenuItem<Company>(value: c, child: Text(c.name));
              }).toList(),
              onChanged: (value) => setState(() {
                _selectedCompany = value;
                _selectedSupervisor = null; // Reset supervisor when company changes
              }),
            ),
            TextButton.icon(
              onPressed: () => _showAddCompanyDialog(provider),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New Company'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupervisorPicker() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final List<Supervisor> supervisorsForCompany = _selectedCompany != null
            ? provider.supervisors.where((s) => s.companyId == _selectedCompany!.id).toList()
            : <Supervisor>[];
            
        return Column(
          children: [
            DropdownButtonFormField<Supervisor>(
              value: _selectedSupervisor,
              decoration: const InputDecoration(
                labelText: 'Select Supervisor',
                prefixIcon: Icon(Icons.person_pin, color: AppColors.secondaryText),
              ),
              items: supervisorsForCompany.map((s) {
                return DropdownMenuItem<Supervisor>(value: s, child: Text(s.name));
              }).toList(),
              onChanged: (value) => setState(() => _selectedSupervisor = value),
              disabledHint: const Text('Select a company first'),
            ),
            TextButton.icon(
              onPressed: _selectedCompany == null ? null : () => _showAddSupervisorDialog(provider),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New Supervisor'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusPicker() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
        labelText: 'Status',
        prefixIcon: Icon(Icons.info_outline, color: AppColors.secondaryText),
      ),
      items: _statusOptions.map((s) {
        return DropdownMenuItem(value: s, child: Text(s));
      }).toList(),
      onChanged: (value) => setState(() => _status = value!),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isStart) {
    return InkWell(
      onTap: () => _selectDate(context, isStart),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today, color: AppColors.secondaryText),
        ),
        child: Text(DateFormat('MMM dd, yyyy').format(date)),
      ),
    );
  }

  void _showAddCompanyDialog(AppProvider provider) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Company'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Company Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final id = await provider.addCompany(Company(name: nameController.text));
                setState(() {
                  _selectedCompany = provider.getCompanyById(id);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddSupervisorDialog(AppProvider provider) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Supervisor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: contactController, decoration: const InputDecoration(hintText: 'Contact Info')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && _selectedCompany != null) {
                final id = await provider.addSupervisor(Supervisor(
                  name: nameController.text,
                  contact: contactController.text,
                  companyId: _selectedCompany!.id!,
                ));
                setState(() {
                  _selectedSupervisor = provider.getSupervisorById(id);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
