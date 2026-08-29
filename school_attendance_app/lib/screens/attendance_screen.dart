import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_attendance_app/database/database_helper.dart';
import 'package:school_attendance_app/models/class_model.dart';
import 'package:school_attendance_app/models/subject.dart';
import 'package:school_attendance_app/models/student.dart';
import 'package:school_attendance_app/theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedClassId;
  int? _selectedSubjectId;
  
  List<ClassModel> _classes = [];
  List<Subject> _subjects = [];
  List<Student> _students = [];
  Map<int, String> _attendanceStatus = {}; // studentId -> status

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final classMaps = await DatabaseHelper.instance.queryAllClasses();
    final loadedClasses = classMaps.map((e) => ClassModel.fromMap(e)).toList();
    
    setState(() {
      _classes = loadedClasses;
      _isLoading = false;
    });

    if (_selectedClassId != null) {
      await _reloadSubjects(_selectedClassId!);
    }
  }

  Future<void> _reloadSubjects(int classId) async {
    final subjectMaps = await DatabaseHelper.instance.querySubjectsByClass(classId);
    setState(() {
      _subjects = subjectMaps.map((e) => Subject.fromMap(e)).toList();
    });
  }

  Future<void> _onClassChanged(int? classId) async {
    if (classId == null) return;
    setState(() {
      _selectedClassId = classId;
      _selectedSubjectId = null;
      _subjects = [];
      _students = [];
      _attendanceStatus = {};
    });
    await _reloadSubjects(classId);

    if (_subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No subjects found for this class. Please add subjects first.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loadStudentsAndAttendance() async {
    if (_selectedClassId == null || _selectedSubjectId == null) return;

    setState(() => _isLoading = true);
    try {
      final studentMaps = await DatabaseHelper.instance.queryStudentsByClass(_selectedClassId!);
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final attendanceMaps = await DatabaseHelper.instance.queryAttendance(_selectedSubjectId!, dateStr);

      final Map<int, String> statusMap = {};
      for (var att in attendanceMaps) {
        statusMap[att['student_id']] = att['status'];
      }

      setState(() {
        _students = studentMaps.map((e) => Student.fromMap(e)).toList();
        _attendanceStatus = statusMap;
        for (var student in _students) {
          if (!_attendanceStatus.containsKey(student.id)) {
            _attendanceStatus[student.id!] = 'Present';
          }
        }
        _isLoading = false;
      });
      
      if (_students.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No students found in this class')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveAttendance() async {
    if (_selectedSubjectId == null) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    setState(() => _isLoading = true);
    try {
      for (var entry in _attendanceStatus.entries) {
        await DatabaseHelper.instance.insertAttendance({
          'student_id': entry.key,
          'subject_id': _selectedSubjectId,
          'date': dateStr,
          'status': entry.value,
        });
      }
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully to Cloud')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadInitialData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _students.isEmpty
                    ? const Center(child: Text('Select Class and Subject to load students'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final student = _students[index];
                          final status = _attendanceStatus[student.id];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text('Roll: ${student.rollNumber}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  _statusButton(student.id!, 'P', 'Present', Colors.green, status == 'Present'),
                                  const SizedBox(width: 8),
                                  _statusButton(student.id!, 'A', 'Absent', Colors.red, status == 'Absent'),
                                  const SizedBox(width: 8),
                                  _statusButton(student.id!, 'L', 'Late', Colors.orange, status == 'Late'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          if (_students.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAVE ATTENDANCE'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusButton(int studentId, String short, String full, Color color, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _attendanceStatus[studentId] = full;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          short,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.secondaryBackground,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
                if (_selectedSubjectId != null) _loadStudentsAndAttendance();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM yyyy').format(_selectedDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            isExpanded: true,
            value: _selectedClassId,
            hint: const Text('Select Class'),
            items: _classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: _onClassChanged,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey(_selectedClassId), // Force rebuild when class changes
            isExpanded: true,
            value: _selectedSubjectId,
            hint: Text(_subjects.isEmpty && _selectedClassId != null ? 'No Subjects Found' : 'Select Subject'),
            items: _subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (val) {
              setState(() => _selectedSubjectId = val);
              _loadStudentsAndAttendance();
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
