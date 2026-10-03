import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/team_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/team_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);
    await context.read<TeamProvider>().createTeam(
          _teamNameController.text.trim(),
          TeamMember(id: user.id, name: user.name, regNumber: user.regNumber, isLeader: true),
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Team')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Build Team & Project Workspace',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Create a new group and maintain a single shared workspace for all member actions.'),
              const SizedBox(height: 22),
              AppTextField(
                label: 'Team Name',
                controller: _teamNameController,
                prefixIcon: Icons.groups_outlined,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a team name' : null,
              ),
              const SizedBox(height: 22),
              AppButton(label: 'Create Team', onPressed: _submit, isLoading: _isSubmitting),
            ],
          ),
        ),
      ),
    );
  }
}
