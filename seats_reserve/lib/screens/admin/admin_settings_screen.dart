import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/core/constants.dart';
import 'package:seats_reserve/screens/auth/login_screen.dart';
import 'package:seats_reserve/models/settings.dart';
import 'package:seats_reserve/services/supabase_service.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _houseNameController = TextEditingController();
  final _totalSeatsController = TextEditingController();
  final _fineAmountController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    final settings = context.read<DataProvider>().settings;
    if (settings != null) {
      _houseNameController.text = settings.houseName;
      _totalSeatsController.text = settings.totalSeats.toString();
      _fineAmountController.text = settings.fineAmount.toString();
      _deadlineController.text = settings.reservationDeadline;
    } else {
      // Set default values if settings are null
      _houseNameController.text = 'SeatSync';
      _totalSeatsController.text = '30';
      _fineAmountController.text = '200';
      _deadlineController.text = '10:00:00';
    }
  }

  void _saveSettings() async {
    final data = context.read<DataProvider>();
    final settings = data.settings;
    if (settings == null) return;

    final updatedSettings = AppSettings(
      id: settings.id,
      houseName: _houseNameController.text.trim(),
      totalSeats: int.tryParse(_totalSeatsController.text) ?? settings.totalSeats,
      reservationDeadline: _deadlineController.text.trim(),
      fineAmount: double.tryParse(_fineAmountController.text) ?? settings.fineAmount,
      openingTime: settings.openingTime,
      closingTime: settings.closingTime,
    );

    try {
      await data.updateSettings(updatedSettings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings updated successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _deadlineController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _houseNameController,
              decoration: const InputDecoration(labelText: 'Software House Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _totalSeatsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Seats', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fineAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Daily Fine Amount (Rs.)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deadlineController,
              readOnly: true,
              onTap: _selectTime,
              decoration: const InputDecoration(
                labelText: 'Reservation Deadline',
                hintText: 'Select Time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Save Settings'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.orange),
              title: const Text('Switch to Student Login', style: TextStyle(color: Colors.orange)),
              onTap: () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen(initialRole: AppConstants.roleStudent)),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => context.read<AuthProvider>().signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
