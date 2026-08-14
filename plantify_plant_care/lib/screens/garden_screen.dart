import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'plant_detail_screen.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Text('My Garden', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32)),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: AppState(),
            builder: (context, child) {
              final reminders = AppState().reminders;
              if (reminders.isEmpty) {
                return const SliverFillRemaining(child: _EmptyGardenState());
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final reminder = reminders[index];
                      final plant = reminder['plant'];
                      return _GardenCard(plant: plant, time: reminder['time'], index: index);
                    },
                    childCount: reminders.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _EmptyGardenState extends StatelessWidget {
  const _EmptyGardenState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.spa_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text('Your garden is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          const Text('Add plants to start tracking care', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _GardenCard extends StatelessWidget {
  final dynamic plant;
  final String time;
  final int index;

  const _GardenCard({required this.plant, required this.time, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantDetailScreen(plant: plant))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            // Wrapped in SizedBox to prevent error text from expanding and causing overflows
            SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  plant.imageUrl, 
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.grey[100], child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.softGreen, 
                    child: const Icon(Icons.broken_image, color: AppTheme.primaryGreen)
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryGreen),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.softGreen, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop, size: 14, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text(time, style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppState().removeReminder(index);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task marked as complete!'), behavior: SnackBarBehavior.floating));
              },
              icon: const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
