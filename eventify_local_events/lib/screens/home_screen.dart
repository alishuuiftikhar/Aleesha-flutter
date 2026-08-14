import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSearchBar(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Featured Events'),
            _buildFeaturedEvents(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Categories'),
            _buildCategories(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Popular Events'),
            _buildPopularEvents(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Upcoming Events'),
            _buildUpcomingEvents(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find events in', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('New York, USA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white.withAlpha(51),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Hello, Aleesha!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('Discover what\'s happening near you', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: TextField(
          onChanged: (val) => context.read<EventProvider>().setSearchQuery(val),
          decoration: const InputDecoration(
            hintText: 'Search for events...',
            prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
          TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildFeaturedEvents(BuildContext context) {
    final featured = context.watch<EventProvider>().featuredEvents;
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24),
        itemCount: featured.length,
        itemBuilder: (context, index) => EventCard(event: featured[index], isHorizontal: true),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = ['All', 'Music', 'Tech', 'Food', 'Art', 'Sports', 'Party'];
    final icons = [Icons.grid_view_rounded, Icons.music_note, Icons.computer, Icons.restaurant, Icons.palette, Icons.sports_basketball, Icons.celebration];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final Color catColor = AppTheme.categoryColors[categories[index]] ?? AppTheme.primaryColor;
          return GestureDetector(
            onTap: () => context.read<EventProvider>().setCategory(categories[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: index == 0 ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppTheme.primaryColor.withAlpha(25)),
                boxShadow: [
                  if (index == 0)
                    BoxShadow(color: AppTheme.primaryColor.withAlpha(50), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(icons[index], color: index == 0 ? Colors.white : catColor, size: 18),
                  const SizedBox(width: 8),
                  Text(categories[index], style: TextStyle(color: index == 0 ? Colors.white : AppTheme.primaryText, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularEvents(BuildContext context) {
    final events = context.watch<EventProvider>().events.reversed.take(5).toList();
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24),
        itemCount: events.length,
        itemBuilder: (context, index) => EventCard(event: events[index], isHorizontal: true),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final provider = context.watch<EventProvider>();
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final events = provider.events;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: events.length > 10 ? 10 : events.length,
      itemBuilder: (context, index) => EventCard(event: events[index]),
    );
  }
}
