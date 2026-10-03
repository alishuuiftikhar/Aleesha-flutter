import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import '../theme.dart';

class DepartmentsListScreen extends StatefulWidget {
  const DepartmentsListScreen({super.key});

  @override
  State<DepartmentsListScreen> createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen> {
  List<Department> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('departments').select();
      setState(() {
        _departments = (response as List).map((json) => Department.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _departments.isEmpty
              ? const Center(child: Text('No departments found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _departments.length,
                  itemBuilder: (context, index) {
                    final dept = _departments[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.corporate_fare, color: AppColors.primary),
                        title: Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
    );
  }
}
