import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';
import 'courses_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  String studentName = "Student";
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
  }

  Future<void> _fetchStudentProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase.from('users').select().eq('id', user.id).single();
      setState(() {
        studentName = data['name'] ?? 'Student';
        avatarUrl = data['avatar_url'];
      });
    } catch (e) {
      print('Profile fetch error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Profile Picture Upload Function
  Future<void> _uploadAvatar() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final fileName = '${supabase.auth.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Upload to Supabase Storage Bucket 'avatars'
        await supabase.storage.from('avatars').uploadBinary(fileName, bytes);
        final imageUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

        // Update database
        await supabase.from('users').update({'avatar_url': imageUrl}).eq('id', supabase.auth.currentUser!.id);

        setState(() {
          avatarUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COMSATS Portal (CUOnline)'),
        backgroundColor: const Color(0xFF4682B4), // Steel Blue
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountText: Text(supabase.auth.currentUser?.email ?? ''),
              currentAccountPicture: GestureDetector(
                onTap: _uploadAvatar,
                child: CircleAvatar(
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  backgroundColor: Colors.white,
                  child: avatarUrl == null ? const Icon(Icons.person, size: 40, color: Color(0xFF4682B4)) : null,
                ),
              ),
              decoration: const BoxDecoration(color: Color(0xFF4682B4)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Courses & Registration'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CoursesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Fee Vouchers / Details'),
              onTap: () {
                Navigator.pop(context);
                // Fee screen route here
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await supabase.auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // University Header Banner with Profile Image container (Like COMSATS Portal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A), // Dark University Blue
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'COMSATS UNIVERSITY ISLAMABAD',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Profile Picture Frame
                  GestureDetector(
                    onTap: _uploadAvatar,
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: avatarUrl != null
                                  ? NetworkImage(avatarUrl!)
                                  : const NetworkImage('https://via.placeholder.com/150') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 18, color: Color(0xFF4682B4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    studentName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text('Student Portal', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 20),

            // Portal Options Grid / List (Fee, Result, Courses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.menu_book, color: Color(0xFF4682B4)),
                      title: const Text('My Courses & Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('View enrolled subjects and study material'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoursesScreen()));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.green),
                      title: const Text('Semester Fee Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Check challan status and dues'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Fee details action
                      },
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2, end: 0).fadeIn(),
          ],
        ),
      ),
    );
  }
}