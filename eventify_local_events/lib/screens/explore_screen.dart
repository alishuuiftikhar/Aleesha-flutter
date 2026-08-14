import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'event_details_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Events'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () => _showFilterBottomSheet(context)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
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
                  hintText: 'Search by event name...',
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          _buildDiscoveryChips(),
          const SizedBox(height: 16),
          _buildCategoryChips(context),
          Expanded(
            child: context.watch<EventProvider>().isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) => _EventGridItem(event: events[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryChips() {
    final discoveryTypes = ['Popular', 'Trending', 'Nearby', 'Upcoming'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: discoveryTypes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(discoveryTypes[index]),
              selected: index == 0,
              onSelected: (v) {},
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryColor.withAlpha(25),
              checkmarkColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppTheme.primaryColor.withAlpha(25))),
              labelStyle: TextStyle(
                color: index == 0 ? AppTheme.primaryColor : AppTheme.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final categories = ['All', 'Music', 'Tech', 'Food', 'Art', 'Sports', 'Party'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(categories[index]),
              onPressed: () => context.read<EventProvider>().setCategory(categories[index]),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppTheme.primaryColor.withAlpha(25))),
              labelStyle: const TextStyle(color: AppTheme.primaryText, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 24),
            const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            RangeSlider(
              values: const RangeValues(20, 80),
              max: 500,
              divisions: 10,
              labels: const RangeLabels('\$20', '\$80'),
              onChanged: (v) {},
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            Wrap(
              spacing: 8,
              children: ['Popularity', 'Date', 'Price']
                  .map((s) => ChoiceChip(
                        label: Text(s),
                        selected: s == 'Date',
                        onSelected: (v) {},
                        selectedColor: AppTheme.primaryColor.withAlpha(25),
                        labelStyle: TextStyle(color: s == 'Date' ? AppTheme.primaryColor : AppTheme.primaryText, fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventGridItem extends StatelessWidget {
  final dynamic event;
  const _EventGridItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = AppTheme.categoryColors[event.category] ?? AppTheme.primaryColor;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 10, color: AppTheme.secondaryText),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(color: AppTheme.secondaryText, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('\$${event.price}', style: TextStyle(color: categoryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
