import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'ticket_selection_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = AppTheme.categoryColors[event.category] ?? AppTheme.primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: Icon(
                          event.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: event.isFavorite ? AppTheme.favorite : Colors.white,
                        ),
                        onPressed: () => context.read<EventProvider>().toggleFavorite(event.id),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: categoryColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                            child: Text(event.category, style: TextStyle(color: categoryColor, fontWeight: FontWeight.bold)),
                          ),
                          Text('\$${event.price}', style: const TextStyle(color: AppTheme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(event.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                      const SizedBox(height: 24),
                      _buildInfoRow(Icons.calendar_today, 'Date and Time', '${DateFormat('EEEE, dd MMM').format(event.date)} • ${event.time}'),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.location_on, 'Location', event.location),
                      const SizedBox(height: 16),
                      _buildOrganizerRow(event),
                      const SizedBox(height: 32),
                      const Text('About Event', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                      const SizedBox(height: 12),
                      Text(event.description, style: const TextStyle(fontSize: 16, color: AppTheme.secondaryText, height: 1.5)),
                      const SizedBox(height: 32),
                      const Text('Event Rules', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                      const SizedBox(height: 12),
                      _buildRuleItem('No outside food or drinks allowed.'),
                      _buildRuleItem('Entry only with a valid digital or printed ticket.'),
                      _buildRuleItem('Please arrive at least 30 minutes before the start.'),
                      const SizedBox(height: 32),
                      const Text('Venue & Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                      const SizedBox(height: 12),
                      Text(event.address, style: const TextStyle(fontSize: 14, color: AppTheme.secondaryText)),
                      const SizedBox(height: 16),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: const Text('View on Map', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketSelectionScreen(event: event))),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Book Tickets Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
            Text(subtitle, style: const TextStyle(color: AppTheme.primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrganizerRow(Event event) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(event.organizerImage), radius: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.organizer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
            const Text('Organizer', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
          ],
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
          child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(rule, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14))),
        ],
      ),
    );
  }
}
