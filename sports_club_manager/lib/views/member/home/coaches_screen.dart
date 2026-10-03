import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CoachesScreen extends StatelessWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaches = [
      {'name': 'Alex Johnson', 'specialty': 'HIIT & Strength', 'image': 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?q=80&w=400'},
      {'name': 'Sarah Williams', 'specialty': 'Yoga & Pilates', 'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?q=80&w=400'},
      {'name': 'Mike Ross', 'specialty': 'Tennis Pro', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400'},
      {'name': 'David Chen', 'specialty': 'Swimming', 'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Our Coaches')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coaches.length,
        itemBuilder: (context, index) {
          final coach = coaches[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(coach['image']!),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handled by CircleAvatar internally to show default background
                },
                child: coach['image'] == null ? const Icon(Icons.person) : null,
              ),
              title: Text(coach['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(coach['specialty']!),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(minimumSize: const Size(60, 32)),
                child: const Text('Profile'),
              ),
            ),
          );
        },
      ),
    );
  }
}
