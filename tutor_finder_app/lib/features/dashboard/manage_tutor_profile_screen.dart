import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/tutor_model.dart';
import '../../models/subject_model.dart';

class ManageTutorProfileScreen extends StatefulWidget {
  const ManageTutorProfileScreen({super.key});

  @override
  State<ManageTutorProfileScreen> createState() => _ManageTutorProfileScreenState();
}

class _ManageTutorProfileScreenState extends State<ManageTutorProfileScreen> {
  final _bioController = TextEditingController();
  final _expController = TextEditingController();
  final _rateController = TextEditingController();
  List<SubjectModel> _allSubjects = [];
  List<int> _selectedSubjectIds = [];
  bool _isLoading = true;
  TutorModel? _tutor;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      
      // Fix: Fetch by profile_id and get the real Tutor ID
      final List<Map<String, dynamic>> tutorData = await Supabase.instance.client
          .from('tutors')
          .select()
          .eq('profile_id', user!.id);
      
      final subjects = await service.getSubjects();
      
      if (mounted) {
        setState(() {
          _allSubjects = subjects;
          if (tutorData.isNotEmpty) {
            final data = tutorData.first;
            _bioController.text = data['bio'] ?? '';
            _expController.text = data['experience'] ?? '';
            _rateController.text = (data['hourly_rate'] ?? 0).toString();
            _loadTutorSubjects(data['id']);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadTutorSubjects(String tutorId) async {
    final List data = await Supabase.instance.client
        .from('tutor_subjects')
        .select('subject_id')
        .eq('tutor_id', tutorId);
    if (mounted) {
      setState(() {
        _selectedSubjectIds = data.map((e) => e['subject_id'] as int).toList();
      });
    }
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      
      // Update tutor table
      await Supabase.instance.client.from('tutors').upsert({
        'profile_id': user!.id,
        'bio': _bioController.text,
        'experience': _expController.text,
        'hourly_rate': double.parse(_rateController.text),
      });

      final tutorData = await Supabase.instance.client
          .from('tutors')
          .select('id')
          .eq('profile_id', user.id)
          .single();
      final tutorId = tutorData['id'];

      // Update subjects (delete and re-insert)
      await Supabase.instance.client.from('tutor_subjects').delete().eq('tutor_id', tutorId);
      for (var id in _selectedSubjectIds) {
        await Supabase.instance.client.from('tutor_subjects').insert({
          'tutor_id': tutorId,
          'subject_id': id,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tutor Profile Updated!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tutor Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Professional Bio', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _bioController, maxLines: 3, decoration: const InputDecoration(hintText: 'Describe your teaching style...')),
            const SizedBox(height: 20),
            const Text('Experience', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _expController, decoration: const InputDecoration(hintText: 'e.g. 5 years in Mathematics')),
            const SizedBox(height: 20),
            const Text('Hourly Rate (\$)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _rateController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 25.00')),
            const SizedBox(height: 20),
            const Text('Select Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _allSubjects.map((subject) {
                final isSelected = _selectedSubjectIds.contains(subject.id);
                return FilterChip(
                  label: Text(subject.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSubjectIds.add(subject.id);
                      } else {
                        _selectedSubjectIds.remove(subject.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _saveProfile, child: const Text('Save Tutor Profile')),
          ],
        ),
      ),
    );
  }
}
