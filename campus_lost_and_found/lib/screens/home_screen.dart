import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import 'report_form_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Connect', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final recentLost = provider.items.where((i) => i.type == ReportType.lost).take(5).toList();
          final recentFound = provider.items.where((i) => i.type == ReportType.found).take(5).toList();
          final myReports = provider.items.where((i) => i.reporterId == provider.currentUserId).toList();
          
          // Simple potential matches for my lost items
          final potentialMatches = <LostFoundItem>[];
          for (var item in myReports.where((i) => i.type == ReportType.lost)) {
            potentialMatches.addAll(provider.findMatches(item));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                if (potentialMatches.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Potential Matches', Icons.auto_awesome),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: potentialMatches.length,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          item: potentialMatches[index],
                          width: 280,
                          onTap: () => _navigateToDetail(context, potentialMatches[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                _buildSectionTitle(context, 'Recent Found Items', Icons.search),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentFound.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        item: recentFound[index],
                        width: 160,
                        onTap: () => _navigateToDetail(context, recentFound[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Recent Lost Items', Icons.help_outline),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentLost.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        item: recentLost[index],
                        width: 160,
                        onTap: () => _navigateToDetail(context, recentLost[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportFormScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Report Item', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Found something?',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Help your fellow students by reporting found items.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/2822/2822765.png',
            height: 80,
            errorBuilder: (c, e, s) => const Icon(Icons.volunteer_activism, size: 60, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            // Navigate to explore with filter
          },
          child: const Text('See All'),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, LostFoundItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
    );
  }
}
