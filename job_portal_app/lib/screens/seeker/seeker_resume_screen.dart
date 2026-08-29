import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp;
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class SeekerResumeScreen extends StatefulWidget {
  const SeekerResumeScreen({super.key});

  @override
  State<SeekerResumeScreen> createState() => _SeekerResumeScreenState();
}

class _SeekerResumeScreenState extends State<SeekerResumeScreen> {
  bool _isLoading = false;
  String? _resumeUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = SupabaseService.client.auth.currentUser;
    if (user != null) {
      final profile = await SupabaseService.getProfile(user.id);
      setState(() => _resumeUrl = profile?['resume_url']);
    }
  }

  Future<void> _uploadResume() async {
    try {
      // Use FilePicker.pickFile() for the new version 12.x API
      final result = await fp.FilePicker.pickFile(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() => _isLoading = true);
        
        // Simulating upload to Supabase Storage
        const fakeUrl = "https://example.com/resumes/my_resume.pdf";
        
        final userId = SupabaseService.client.auth.currentUser!.id;
        await SupabaseService.updateProfile(userId, {'resume_url': fakeUrl});
        
        setState(() {
          _resumeUrl = fakeUrl;
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume uploaded successfully!')));
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Resume')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.description, size: 80, color: AppConstants.primaryColor),
              const SizedBox(height: 24),
              if (_resumeUrl != null) ...[
                const Text('Current Resume:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('my_resume.pdf', overflow: TextOverflow.ellipsis)),
                      IconButton(icon: const Icon(Icons.download), onPressed: () {}),
                    ],
                  ),
                ),
              ] else 
                const Text('No resume uploaded yet.', style: TextStyle(color: Colors.grey)),
              
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _uploadResume,
                icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.upload_file),
                label: Text(_resumeUrl != null ? 'Update Resume' : 'Upload Resume'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
