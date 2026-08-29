import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp;
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class ApplicationFormScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ApplicationFormScreen({super.key, required this.job});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _coverLetterController = TextEditingController();
  fp.PlatformFile? _resume;
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final profile = await SupabaseService.getProfile(user.id);
        if (profile != null) {
          setState(() {
            _nameController.text = profile['full_name'] ?? '';
            _phoneController.text = profile['phone'] ?? '';
          });
        }
      }
    } catch (e) {
      // Silent error
    } finally {
      setState(() => _isFetching = false);
    }
  }

  Future<void> _pickResume() async {
    try {
      // Use FilePicker.pickFile() for the new version 12.x API
      final result = await fp.FilePicker.pickFile(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() => _resume = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _submitApplication() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }
    if (_resume == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload your resume')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');
      
      final userId = user.id;

      // Update profile with personal details entered in the form
      await SupabaseService.updateProfile(userId, {
        'full_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
      
      // In a real app, you would upload the file to Supabase Storage here
      // and get the URL. For this demo, we'll use a placeholder URL.
      const resumeUrl = 'https://example.com/resume.pdf';

      await SupabaseService.applyForJob(
        widget.job['id'].toString(),
        userId,
        resumeUrl,
        _coverLetterController.text.trim(),
      );

      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Application Submitted'),
          content: const Text('Your application has been sent successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close form
                Navigator.pop(context); // Close job details
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Job')),
      body: _isFetching 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Applying for ${widget.job['title']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job['companies']?['name'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text('Personal Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            const Text('Resume (PDF, DOC)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickResume,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  color: AppConstants.secondaryBackground,
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload, size: 48, color: AppConstants.primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      _resume != null ? _resume!.name : 'Click to upload resume',
                      style: const TextStyle(color: AppConstants.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Cover Letter', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _coverLetterController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Tell the employer why you are a good fit...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitApplication,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
