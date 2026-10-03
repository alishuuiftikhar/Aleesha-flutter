import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/team_provider.dart';
import '../../providers/submission_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class SubmissionUploadScreen extends StatefulWidget {
  const SubmissionUploadScreen({super.key});

  @override
  State<SubmissionUploadScreen> createState() => _SubmissionUploadScreenState();
}

class _SubmissionUploadScreenState extends State<SubmissionUploadScreen> {
  String _type = AppConstants.submissionTypes.first;
  final _fileNameController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    final team = context.read<TeamProvider>().myTeam;
    if (team == null) return;
    if (_fileNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attach a file name (simulated upload).')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await context.read<SubmissionProvider>().submit(
          teamId: team.id,
          type: _type,
          fileName: _fileNameController.text.trim(),
          windowDeadline: DateTime.now().add(const Duration(days: 10)),
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Submission')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Upload proposal, SRS, design, progress, or final reports inside the active submission window.'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Submission Type'),
              items: AppConstants.submissionTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'File name (e.g. srs_v2.pdf)',
              controller: _fileNameController,
              prefixIcon: Icons.attach_file,
            ),
            const SizedBox(height: 6),
            const Text(
              'Attach real file selection via file_picker in production; simulated here with a file name.',
              style: TextStyle(fontSize: 11.5, color: Colors.grey),
            ),
            const SizedBox(height: 22),
            AppButton(label: 'Submit', onPressed: _submit, isLoading: _isSubmitting),
          ],
        ),
      ),
    );
  }
}
