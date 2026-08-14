import 'package:flutter/material.dart';
import 'package:urban_drive_car_rental/theme/app_theme.dart';
import 'package:urban_drive_car_rental/services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService(),
      builder: (context, child) {
        final user = UserService();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _navigateToSubPage(context, const EditProfileScreen()),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.lightPurple,
                        child: Icon(Icons.person, size: 60, color: AppTheme.primaryPurple),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _navigateToSubPage(context, const EditProfileScreen()),
                          child: const CircleAvatar(
                            backgroundColor: AppTheme.primaryPurple,
                            radius: 18,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 40),
                _buildProfileItem(context, Icons.person_outline, 'Personal Info', const EditProfileScreen()),
                _buildProfileItem(context, Icons.payment_outlined, 'Payment Methods', const PaymentMethodsScreen()),
                _buildProfileItem(context, Icons.history_outlined, 'Ride History', const RideHistoryScreen()),
                _buildProfileItem(context, Icons.settings_outlined, 'Settings', const SettingsScreen()),
                _buildProfileItem(context, Icons.help_outline, 'Help & Support', const SupportScreen()),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToSubPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, Widget targetScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: () => _navigateToSubPage(context, targetScreen),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = UserService();
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await UserService().updateProfile(
                _nameController.text,
                _emailController.text,
                _phoneController.text,
              );
              if (mounted) Navigator.pop(context);
            }, 
            child: const Text('SAVE CHANGES')
          ),
        ],
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _card(Icons.credit_card, 'Visa Ending in 4242', 'Exp 12/26'),
          _card(Icons.account_balance_wallet, 'Easypaisa', '0300 **** 789'),
          const SizedBox(height: 24),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('ADD NEW METHOD')),
        ],
      ),
    );
  }
  Widget _card(IconData icon, String title, String sub) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(sub), trailing: const Icon(Icons.more_vert)));
}

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride History')),
      body: const Center(child: Text('No previous ride history found.', style: TextStyle(color: AppTheme.textSecondary))),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifications'), 
            value: _notifications, 
            onChanged: (v) => setState(() => _notifications = v)
          ),
          const ListTile(title: Text('Language'), trailing: Text('English')),
          const ListTile(title: Text('App Version'), trailing: Text('1.0.0')),
        ],
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ListTile(leading: Icon(Icons.email), title: Text('Email Us'), subtitle: Text('support@urbandrive.com')),
          ListTile(leading: Icon(Icons.phone), title: Text('Call Us'), subtitle: Text('+92 300 1234567')),
        ],
      ),
    );
  }
}
