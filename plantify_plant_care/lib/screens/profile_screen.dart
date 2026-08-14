import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'onboarding_screen.dart';
import 'notifications_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Aleesha');
  final _emailController = TextEditingController(text: 'plant.lover@example.com');
  final _phoneController = TextEditingController(text: '+92 300 1234567');
  bool _isEditing = false;
  
  final User? user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _emailController.text = user!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPremiumHeader(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: 25),
                  _buildInfoSection(),
                  const SizedBox(height: 20),
                  _buildActionMenu(),
                  const SizedBox(height: 30),
                  _buildLogoutButton(),
                  const SizedBox(height: 130), // Padding for floating nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            const SizedBox(height: 65), // Space for profile pic to overflow
            Text(
              _nameController.text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
            ),
            Text(
              _emailController.text,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
          ],
        ),
        // Profile Picture
        Positioned(
          top: 110,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.softGreen,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=400'),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isEditing = !_isEditing),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppTheme.accentGreen, shape: BoxShape.circle),
                  child: Icon(_isEditing ? Icons.check : Icons.edit, color: AppTheme.primaryGreen, size: 20),
                ),
              ),
            ],
          ),
        ),
        // App Bar Actions
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('My Plants', '12'),
          _buildStatItem('Score', '9.8'),
          _buildStatItem('Followers', '840'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Account Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            if (_isEditing)
              GestureDetector(
                onTap: () {
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!')));
                },
                child: const Text('SAVE', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 15),
        _buildInfoCard(Icons.person_outline, 'Name', _nameController),
        const SizedBox(height: 10),
        _buildInfoCard(Icons.email_outlined, 'Email', _emailController),
        const SizedBox(height: 10),
        _buildInfoCard(Icons.phone_outlined, 'Phone', _phoneController),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                TextField(
                  controller: controller,
                  enabled: _isEditing,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu() {
    return Column(
      children: [
        _buildMenuItem(Icons.favorite_outline, 'My Favorites', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()))),
        _buildMenuItem(Icons.history, 'Order History', () {}),
        _buildMenuItem(Icons.settings_outlined, 'Settings', () {}),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryGreen),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: () {
        Supabase.instance.client.auth.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      },
      child: const Text('Log Out Account', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    );
  }
}
