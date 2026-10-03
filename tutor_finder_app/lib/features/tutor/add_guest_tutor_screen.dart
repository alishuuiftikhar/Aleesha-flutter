import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../models/subject_model.dart';
import 'dart:math';

class AddGuestTutorScreen extends StatefulWidget {
  const AddGuestTutorScreen({super.key});

  @override
  State<AddGuestTutorScreen> createState() => _AddGuestTutorScreenState();
}

class _AddGuestTutorScreenState extends State<AddGuestTutorScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _expController = TextEditingController();
  final _rateController = TextEditingController();
  List<SubjectModel> _allSubjects = [];
  final List<int> _selectedSubjectIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    final List data = await Supabase.instance.client.from('subjects').select();
    if (mounted) {
      setState(() {
        _allSubjects = data.map((e) => SubjectModel.fromJson(e)).toList();
      });
    }
  }

  void _addTutor() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final client = Supabase.instance.client;
      // Note: This is for demo/admin purposes. In a real app, users sign up via Auth.
      // We are creating a "Guest Profile" not linked to a real Auth user.
      final newId = '00000000-0000-0000-0000-${Random().nextInt(999999999).toString().padLeft(12, '0')}';
      
      await client.from('profiles').insert({
        'id': newId,
        'email': _emailController.text,
        'full_name': _nameController.text,
        'role': 'tutor',
      });

      final tutorResult = await client.from('tutors').insert({
        'profile_id': newId,
        'bio': _bioController.text,
        'experience': _expController.text,
        'hourly_rate': double.parse(_rateController.text),
      }).select().single();

      final tutorId = tutorResult['id'];

      for (var sId in _selectedSubjectIds) {
        await client.from('tutor_subjects').insert({
          'tutor_id': tutorId,
          'subject_id': sId,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New Tutor Added Successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Tutor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Full Name')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'Email Address')),
            const SizedBox(height: 24),
            const Text('Tutor Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(controller: _bioController, maxLines: 2, decoration: const InputDecoration(hintText: 'Professional Bio')),
            const SizedBox(height: 12),
            TextField(controller: _expController, decoration: const InputDecoration(hintText: 'Experience (e.g. 5 Years)')),
            const SizedBox(height: 12),
            TextField(controller: _rateController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Hourly Rate (\$)')),
            const SizedBox(height: 24),
            const Text('Select Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _allSubjects.map((s) {
                final isSelected = _selectedSubjectIds.contains(s.id);
                return FilterChip(
                  label: Text(s.name),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) _selectedSubjectIds.add(s.id);
                      else _selectedSubjectIds.remove(s.id);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: _addTutor, child: const Text('Register Tutor')),
          ],
        ),
      ),
    );
  }
}
