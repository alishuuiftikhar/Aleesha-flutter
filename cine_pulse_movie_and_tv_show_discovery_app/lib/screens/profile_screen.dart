import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/theme_provider.dart';
import 'account_settings_screen.dart';
import 'generic_info_screen.dart';
import 'watchlist_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  
  String _name = 'Aleesha Khan';
  String _email = 'aleesha.khan@example.com';
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _storageService.getProfileData();
    final img = await _storageService.getProfilePic();
    setState(() {
      _name = data['name']!;
      _email = data['email']!;
      _imagePath = img;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _storageService.saveProfilePic(image.path);
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image. Please check permissions.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF5B21B6), width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      backgroundImage: _imagePath != null && File(_imagePath!).existsSync()
                          ? FileImage(File(_imagePath!))
                          : null,
                      child: _imagePath == null || !File(_imagePath!).existsSync()
                          ? Icon(Icons.person, size: 70, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF8B5CF6),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            Text(
              _email,
              style: const TextStyle(color: Color(0xFFC4B5FD), fontSize: 14),
            ),
            const SizedBox(height: 30),
            
            // Dark Mode Toggle Switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: const Color(0xFFC4B5FD),
                  ),
                  title: const Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeColor: const Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ),

            _buildSettingsGroup('Personal', [
              _buildSettingsItem(Icons.person_outline, 'Account Settings', () async {
                final updated = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
                if (updated == true) _loadProfile();
              }),
              _buildSettingsItem(Icons.bookmark_outline, 'My Watchlist', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WatchlistScreen()));
              }),
            ]),

            _buildSettingsGroup('Support', [
              _buildSettingsItem(Icons.help_outline, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GenericInfoScreen(title: 'Help & Support')));
              }),
              _buildSettingsItem(Icons.info_outline, 'About CinePulse', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GenericInfoScreen(title: 'About CinePulse')));
              }),
            ]),
            
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18181B),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(color: Color(0xFFC4B5FD), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor, 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon, color: const Color(0xFFC4B5FD), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
