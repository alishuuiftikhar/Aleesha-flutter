import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../utils/app_colors.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics & Journal'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'Stats'),
            Tab(text: 'Journal'),
          ],
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildStatsTab(state),
              _buildJournalTab(state),
            ],
          );
        },
      ),
      floatingActionButton: _tabController.index == 1 ? FloatingActionButton(
        onPressed: () => _showAddEntryDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildStatsTab(AppState state) {
    final stats = state.stats;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverview(context, stats),
          const SizedBox(height: 30),
          _buildWeeklyChart(context, state),
          const SizedBox(height: 30),
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          stats.history.isEmpty
              ? const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No activity yet. Start your journey today!'),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.history.length > 5 ? 5 : stats.history.length,
                  itemBuilder: (context, index) {
                    final date = stats.history[stats.history.length - 1 - index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.cardBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: AppColors.secondaryBackground.withOpacity(0.3)),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.secondaryBackground,
                          child: Icon(Icons.check, color: AppColors.primary),
                        ),
                        title: const Text('Meditation Session'),
                        subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(date)),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, AppState state) {
    // Simple bar chart simulation
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Activity", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weekDays.map((day) {
              double height = (day == 'M' || day == 'W' || day == 'F') ? 60.0 : 30.0; // Simulated
              return Column(
                children: [
                  Container(
                    width: 15,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(day, style: const TextStyle(fontSize: 10)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab(AppState state) {
    if (state.stats.journalEntries.isEmpty) {
      return const Center(child: Text("Write your first journal entry to reflect on your journey."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: state.stats.journalEntries.length,
      itemBuilder: (context, index) {
        final entry = state.stats.journalEntries[state.stats.journalEntries.length - 1 - index];
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(entry.date),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                    Text(entry.mood, style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(entry.content, style: const TextStyle(fontSize: 16, height: 1.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Reflection"),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "How do you feel after today's session?",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<AppState>(context, listen: false).addJournalEntry(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(BuildContext context, dynamic stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(context, 'Sessions', stats.totalSessions.toString(), Icons.self_improvement),
        _buildStatCard(context, 'Minutes', stats.totalMinutes.toString(), Icons.timer),
        _buildStatCard(context, 'Streak', '${stats.currentStreak} Days', Icons.local_fire_department),
        _buildStatCard(context, 'Favorites', stats.favoriteSessionIds.length.toString(), Icons.favorite),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSecondary : AppColors.secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkText : AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.text),
          ),
        ],
      ),
    );
  }
}
