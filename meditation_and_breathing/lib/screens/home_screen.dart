import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/app_colors.dart';
import '../widgets/session_card.dart';
import 'meditation_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SereneMind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Mindful Soul',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkText : AppColors.text,
                  ),
                ),
                const SizedBox(height: 25),
                _buildMoodTracker(context, state),
                const SizedBox(height: 25),
                _buildDailyProgress(context, state),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Recommended for You'),
                const SizedBox(height: 15),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      final session = state.sessions[index];
                      return SessionCard(
                        session: session,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeditationDetailScreen(session: session),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                _buildSectionHeader(context, 'Daily Inspiration'),
                const SizedBox(height: 15),
                _buildInspirationCard(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyProgress(BuildContext context, AppState state) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondary : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Goal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${state.stats.totalMinutes} / 30 mins completed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: (state.stats.totalMinutes % 30) / 30,
                  backgroundColor: Colors.white.withOpacity(isDark ? 0.1 : 0.5),
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text(
                  '${state.stats.currentStreak}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('days', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTracker(BuildContext context, AppState state) {
    final moods = [
      {'emoji': '😔', 'label': 'Sad'},
      {'emoji': '😐', 'label': 'Neutral'},
      {'emoji': '😊', 'label': 'Happy'},
      {'emoji': '😌', 'label': 'Calm'},
      {'emoji': '🧘', 'label': 'Zen'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: moods.map((mood) {
            bool isSelected = state.selectedMood == mood['label'];
            return GestureDetector(
              onTap: () => state.setMood(mood['label']!),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10)]
                          : [],
                    ),
                    child: Text(mood['emoji']!, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood['label']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.primary : AppColors.secondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('See All', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildInspirationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: const Column(
        children: [
          Icon(Icons.format_quote, color: AppColors.accent, size: 40),
          Text(
            "\"Peace comes from within. Do not seek it without.\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "- Gautama Buddha",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
