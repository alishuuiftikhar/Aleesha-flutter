import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../services/user_service.dart';
import 'room_booking_screen.dart';
import 'profile_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _service = UserService();
  List<Hotel> _hotels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  void _fetchHotels([String query = '']) async {
    setState(() => _isLoading = true);
    try {
      final list = await _service.getHotels(query: query);
      setState(() => _hotels = list);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading hotels: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Royal Hotel Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileHistoryScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            color: const Color(0xFF0F4C81),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: (val) => _fetchHotels(val),
              decoration: InputDecoration(
                hintText: 'Search city or hotel name...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0F4C81)),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Hotels Listing
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hotels.isEmpty
                ? const Center(child: Text('No hotels available right now.'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _hotels.length,
              itemBuilder: (context, index) {
                final hotel = _hotels[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoomBookingScreen(hotel: hotel),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty
                              ? Image.network(hotel.imageUrl!, height: 160, width: double.infinity, fit: BoxFit.cover)
                              : Container(
                            height: 160,
                            color: Colors.blue.shade100,
                            child: const Center(
                              child: Icon(Icons.hotel, size: 60, color: Color(0xFF0F4C81)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                      Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${hotel.city} • ${hotel.address}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}