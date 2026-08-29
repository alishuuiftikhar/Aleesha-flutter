import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/property_provider.dart';
import '../core/constants.dart';
import 'login_screen.dart';
import 'comparison_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PropertyProvider>().fetchViewings());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final propertyProvider = context.watch<PropertyProvider>();
    final profile = authProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.secondaryBackground,
                backgroundImage: profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
                child: profile?.avatarUrl == null ? const Icon(Icons.person, size: 50, color: AppColors.primary) : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(profile?.fullName ?? 'User Name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(profile?.email ?? 'email@example.com', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(alignment: Alignment.centerLeft, child: Text('My Viewings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 16),
            if (propertyProvider.viewings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('No viewings scheduled.', style: TextStyle(color: Colors.grey[600])),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: propertyProvider.viewings.length,
                itemBuilder: (context, index) {
                  final viewing = propertyProvider.viewings[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ListTile(
                      title: Text(viewing.property?.title ?? 'Property'),
                      subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(viewing.scheduledAt)),
                      trailing: viewing.status == 'cancelled'
                        ? const Text('Cancelled', style: TextStyle(color: Colors.red))
                        : TextButton(
                            onPressed: () => propertyProvider.cancelViewing(viewing.id),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                          ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32),
            _buildProfileOption(Icons.settings, 'Settings', () {}),
            _buildProfileOption(Icons.compare_arrows, 'Compare Properties', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparisonScreen()));
            }),
            _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
            _buildProfileOption(Icons.info_outline, 'About LuxEstate', () {}),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
