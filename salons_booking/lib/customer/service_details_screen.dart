import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                service['image_url'] ?? 'https://images.unsplash.com/photo-1562322140-8baeececf3df?auto=format&fit=crop&q=80&w=2670',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service['name'] ?? 'Service Name',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.softRose,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${service['price']}',
                          style: const TextStyle(color: AppTheme.deepRose, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${service['duration_minutes']} mins', style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      const Text('4.8 (120 reviews)', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepRose),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service['description'] ?? 'No description available.',
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Available Experts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepRose),
                  ),
                  const SizedBox(height: 12),
                  _buildExpertsList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingScreen(service: service)),
              );
            },
            child: const Text('Book Your Beauty Session ✨'),
          ),
        ),
      ),
    );
  }

  Widget _buildExpertsList() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1594744803329-e58b31de2177?auto=format&fit=crop&q=80&w=2574'),
          );
        },
      ),
    );
  }
}
