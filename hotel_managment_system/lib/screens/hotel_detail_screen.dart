import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../widgets/full_screen_image.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final hasImage = hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image (Clickable for full screen)
            GestureDetector(
              onTap: () {
                if (hasImage) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imageUrl: hotel.imageUrl!,
                        tag: hotel.id,
                      ),
                    ),
                  );
                }
              },
              child: Hero(
                tag: hotel.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      hasImage
                          ? Image.network(
                        hotel.imageUrl!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 250,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.hotel, size: 80, color: Colors.grey),
                        ),
                      ),
                      if (hasImage)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(150),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hotel.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                const SizedBox(width: 4),
                Text('${hotel.address}, ${hotel.city}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(height: 30),
            const Text(
              'About Hotel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              hotel.description ?? 'No description provided.',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}