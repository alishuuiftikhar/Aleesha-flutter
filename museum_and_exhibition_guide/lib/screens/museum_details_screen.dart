import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/museum.dart';
import '../models/visit_plan.dart';
import '../services/app_provider.dart';
import '../utils/app_colors.dart';
import 'exhibition_details_screen.dart';

class MuseumDetailsScreen extends StatelessWidget {
  final Museum museum;

  const MuseumDetailsScreen({super.key, required this.museum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(museum.imageUrl, fit: BoxFit.cover),
            ),
            actions: [
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite('museum', museum.id);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                    onPressed: () => provider.toggleFavorite('museum', museum.id),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(museum.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.accent, size: 18),
                      const SizedBox(width: 4),
                      Text(museum.location, style: const TextStyle(color: AppColors.secondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(museum.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 20),
                  _infoCard('Opening Hours', museum.openingHours, Icons.access_time),
                  _infoCard('Tickets', museum.ticketInfo, Icons.confirmation_number_outlined),
                  _infoCard('Visitor Tips', museum.visitorTips, Icons.lightbulb_outline),
                  const SizedBox(height: 30),
                  Text('Featured Exhibitions', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Consumer<AppProvider>(
                    builder: (context, provider, child) {
                      final exhibitions = provider.exhibitions.where((e) => museum.exhibitionIds.contains(e.id)).toList();
                      if (exhibitions.isEmpty) return const Text('No active exhibitions.');
                      return Column(
                        children: exhibitions.map((e) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(e.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(e.title),
                          subtitle: Text(e.type),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExhibitionDetailsScreen(exhibition: e))),
                        )).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Text('Gallery', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: museum.galleryImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(museum.galleryImages[index], width: 160, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => _showAddVisitDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add to Visit Plan'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVisitDialog(BuildContext context) {
    final dateController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Plan Your Visit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Visit Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    selectedDate = date;
                    dateController.text = "${date.year}-${date.month}-${date.day}";
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null) return;
                final plan = VisitPlan(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  museumId: museum.id,
                  museumName: museum.name,
                  visitDate: selectedDate!,
                  notes: notesController.text,
                );
                Provider.of<AppProvider>(context, listen: false).addVisitPlan(plan);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Visit added to your plan!'), backgroundColor: AppColors.highlight),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
