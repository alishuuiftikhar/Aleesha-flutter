import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:csv/csv.dart';
import 'auth_screen.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'My Profile');

  Future<void> _exportData(BuildContext context) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;

      final income = await supabase.from('income').select().eq('user_uuid', userId);
      final expenses = await supabase.from('expenses').select().eq('user_uuid', userId);

      List<List<dynamic>> rows = [];
      rows.add(['Type', 'Title', 'Amount', 'Category', 'Date']);

      for (var i in income) {
        rows.add(['Income', i['title'], i['amount'], i['category'] ?? 'General', i['date']]);
      }
      for (var e in expenses) {
        rows.add(['Expense', e['title'], e['amount'], e['category'] ?? 'General', e['date']]);
      }

      String csvData = const ListToCsvConverter().convert(rows);

      debugPrint(csvData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data exported successfully to CSV format!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF059669),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // User apna naam khud yahan likh sake ga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(user?.email ?? 'No Email', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 30),

            // Dark Mode Switch
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentTheme, _) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: const Icon(Icons.dark_mode),
                  value: currentTheme == ThemeMode.dark,
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),

            // Currency Selector
            ValueListenableBuilder<String>(
              valueListenable: currencyNotifier,
              builder: (context, currentCurrency, _) {
                return ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Select Currency'),
                  trailing: DropdownButton<String>(
                    value: currentCurrency,
                    items: const [
                      DropdownMenuItem<String>(value: '\$', child: Text('USD (\$ )')),
                      DropdownMenuItem<String>(value: 'Rs ', child: Text('PKR/INR (Rs )')),
                      DropdownMenuItem<String>(value: '€', child: Text('Euro (€ )')),
                    ],
                    onChanged: (String? val) {
                      if (val != null) {
                        currencyNotifier.value = val;
                      }
                    },
                  ),
                );
              },
            ),

            const Divider(),

            // CSV Export Button
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Export Data (CSV)'),
              onTap: () => _exportData(context),
            ),

            const SizedBox(height: 40),

            const Center(
              child: Text(
                'Expense Tracker v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}