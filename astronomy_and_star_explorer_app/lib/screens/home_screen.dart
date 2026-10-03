import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';
import '../widgets/glowing_card.dart';
import 'object_details_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COSMOS EXPLORER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizStartScreen())),
          ),
        ],
      ),
      body: Consumer<AstronomyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final bestScore = provider.quizResults.isEmpty 
              ? 0 
              : provider.quizResults.map((r) => r.score).reduce((a, b) => a > b ? a : b);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context),
                const SizedBox(height: 24),
                _buildDailyFact(context),
                const SizedBox(height: 24),
                _buildStatsRow(context, provider.observations.length, bestScore),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Recently Viewed', () {}),
                const SizedBox(height: 12),
                _buildHorizontalList(context, provider.recentlyViewed),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Favorites', () {}),
                const SizedBox(height: 12),
                _buildHorizontalList(context, provider.favorites),
                const SizedBox(height: 24),
                _buildChecklist(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Space Explorer!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
        ),
        const Text(
          'Ready to discover the universe today?',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildDailyFact(BuildContext context) {
    return GlowingCard(
      color: AppColors.highlight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Daily Astronomy Fact',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'A day on Venus is longer than a year on Venus. It takes Venus 243 Earth days to rotate once, but only 225 Earth days to orbit the Sun.',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int totalObs, int bestScore) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(context, 'Observations', totalObs.toString(), Icons.remove_red_eye),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(context, 'Best Quiz Score', '$bestScore', Icons.emoji_events),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: onTap, child: const Text('See All', style: TextStyle(color: AppColors.primary))),
      ],
    );
  }

  Widget _buildHorizontalList(BuildContext context, List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No items yet', style: TextStyle(color: Colors.white38)),
      ));
    }
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Provider.of<AstronomyProvider>(context, listen: false).addToRecentlyViewed(item);
              Navigator.push(context, MaterialPageRoute(builder: (_) => ObjectDetailsScreen(object: item)));
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.bottomLeft,
                child: Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklist(BuildContext context, AstronomyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stargazing Checklist', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.checklist.length.clamp(0, 4),
            itemBuilder: (context, index) {
              final item = provider.checklist[index];
              return CheckboxListTile(
                title: Text(item.title, style: TextStyle(
                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  color: item.isCompleted ? Colors.white38 : Colors.white,
                )),
                value: item.isCompleted,
                onChanged: (_) => provider.toggleChecklist(item),
                activeColor: AppColors.primary,
                checkColor: AppColors.mainBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              );
            },
          ),
        ),
      ],
    );
  }
}
