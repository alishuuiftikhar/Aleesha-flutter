import 'package:flutter/material.dart';
import 'package:school_attendance_app/database/database_helper.dart';
import 'package:school_attendance_app/models/student.dart';
import 'package:school_attendance_app/models/class_model.dart';
import 'package:school_attendance_app/theme/app_theme.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [];
  List<ClassModel> _classes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _selectedClassFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final studentMaps = await DatabaseHelper.instance.queryAllStudents();
    final classMaps = await DatabaseHelper.instance.queryAllClasses();
    setState(() {
      _students = studentMaps.map((e) => Student.fromMap(e)).toList();
      _classes = classMaps.map((e) => ClassModel.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  List<Student> get _filteredStudents {
    return _students.where((student) {
      final matchesSearch = student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesClass = _selectedClassFilter == null || student.classId == _selectedClassFilter;
      return matchesSearch && matchesClass;
    }).toList();
  }

  void _showAddEditStudentDialog([Student? student]) async {
    final nameController = TextEditingController(text: student?.name);
    final rollController = TextEditingController(text: student?.rollNumber);
    int? selectedClassId = student?.classId;

    if (_classes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a class first')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(student == null ? 'Add Student' : 'Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
              ),
              TextField(
                controller: rollController,
                decoration: const InputDecoration(labelText: 'Roll Number'),
              ),
              DropdownButtonFormField<int>(
                value: selectedClassId,
                items: _classes
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedClassId = val),
                decoration: const InputDecoration(labelText: 'Select Class'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    rollController.text.isNotEmpty &&
                    selectedClassId != null) {
                  final newStudent = Student(
                    id: student?.id,
                    name: nameController.text,
                    rollNumber: rollController.text,
                    classId: selectedClassId!,
                  );

                  if (student == null) {
                    await DatabaseHelper.instance.insertStudent(newStudent.toMap());
                  } else {
                    await DatabaseHelper.instance.updateStudent(newStudent.toMap());
                  }
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search by name or roll...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedClassFilter == null,
                          onSelected: (val) => setState(() => _selectedClassFilter = null),
                        ),
                      ),
                      ..._classes.map((c) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(c.name),
                              selected: _selectedClassFilter == c.id,
                              onSelected: (val) => setState(() => _selectedClassFilter = val ? c.id : null),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredStudents.isEmpty
              ? const Center(child: Text('No students found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.secondaryBackground,
                          child: Text(student.name[0], style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Roll: ${student.rollNumber} • ${student.className ?? "No Class"}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddEditStudentDialog(student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteStudent(student.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditStudentDialog(),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
