import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'edit_profile_screen.dart';
import 'welcome_screen.dart';
import '../models/app_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 40),
          // Premium Profile Header
          Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF06292), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFFFCE4EC),
                    backgroundImage: AppData.profilePicPath != null 
                        ? FileImage(File(AppData.profilePicPath!)) 
                        : null,
                    child: AppData.profilePicPath == null 
                        ? const Icon(Icons.person, size: 65, color: Color(0xFFF06292)) 
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const EditProfileScreen())
                      );
                      if (result == true) {
                        setState(() {}); // Forcing rebuild to show new image/name
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFFF06292), shape: BoxShape.circle),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  AppData.registeredName ?? 'Aleesha',
                  style: TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  AppData.registeredEmail ?? 'aleesha@example.com',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                if (AppData.registeredBio != null && AppData.registeredBio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      AppData.registeredBio!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          _buildMenuSection('Personal Settings'),
          _buildThemeToggle(isDark),
          _buildProfileOption(Icons.shopping_bag_outlined, 'My Orders (${AppData.myOrders.length})', () => _showOrdersBottomSheet(context)),
          _buildProfileOption(Icons.payment_outlined, 'Saved Cards', () => _showPaymentMethods(context)),
          _buildProfileOption(Icons.notifications_none_rounded, 'Notifications', () {}),
          
          const SizedBox(height: 30),
          _buildLogoutButton(),
          const SizedBox(height: 100), // Extra space for curved nav
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF06292).withAlpha(20),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFFF06292)),
        title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Switch(
          value: isDark,
          onChanged: (val) {
            InteriorApp.of(context).changeTheme(val);
          },
          activeThumbColor: const Color(0xFFF06292),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF06292).withAlpha(20),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFF06292)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Logout Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _showOrdersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('My Orders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
            const Divider(),
            Expanded(
              child: AppData.myOrders.isEmpty
                  ? const Center(child: Text('No orders yet.'))
                  : ListView.builder(
                      itemCount: AppData.myOrders.length,
                      itemBuilder: (context, index) {
                        final order = AppData.myOrders[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(order.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(order.item.title),
                          subtitle: Text('Status: Processing • ${order.selectedColor}'),
                          trailing: Text(order.item.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Payment Methods', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF06292))),
            const SizedBox(height: 20),
            _buildPaymentItem(Icons.credit_card, 'Visa **** 4242'),
            _buildPaymentItem(Icons.account_balance_wallet, 'Cash on Delivery'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFF06292)),
      title: Text(label),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
    );
  }
}
