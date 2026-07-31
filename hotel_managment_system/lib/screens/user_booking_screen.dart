import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  // Fetch bookings along with hotel and assigned room details from Supabase
  Future<void> _fetchUserBookings() async {
    try {
      setState(() => _isLoading = true);
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Query joining hotels and rooms table
      final response = await _supabase
          .from('bookings')
          .select('*, hotels(name, city), rooms(room_number, room_type, price)')
          .eq('user_id', userId)
          .order('id', ascending: false);

      setState(() {
        _bookings = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookings: $e')),
      );
    }
  }

  // Status Badge Widget (Color & Icon based on status)
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData badgeIcon;
    String lowerStatus = status.toLowerCase();

    if (lowerStatus == 'approved' || lowerStatus == 'confirmed') {
      badgeColor = Colors.green;
      badgeIcon = Icons.check_circle;
    } else if (lowerStatus == 'cancelled' || lowerStatus == 'rejected') {
      badgeColor = Colors.red;
      badgeIcon = Icons.cancel;
    } else {
      badgeColor = Colors.orange; // Pending
      badgeIcon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings & Profile'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(
        child: Text(
          'No bookings found!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchUserBookings,
        child: ListView.builder(
          itemCount: _bookings.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            final hotel = booking['hotels'] ?? {};
            final room = booking['rooms'] ?? {};

            final hotelName = hotel['name'] ?? 'Hotel';
            final roomType = room['room_type'] ?? '';
            final roomNumber = room['room_number'] ?? '';
            final status = booking['status'] ?? 'Pending';

            final checkIn = booking['check_in'] != null
                ? booking['check_in'].toString().split('T')[0]
                : 'N/A';
            final checkOut = booking['check_out'] != null
                ? booking['check_out'].toString().split('T')[0]
                : 'N/A';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hotel Name & Status Badge
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hotelName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 2. Assigned Room Details Box inside the card
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.meeting_room,
                              size: 18, color: Color(0xFF0F4C81)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              roomType.isNotEmpty
                                  ? 'Room: $roomType ${roomNumber.isNotEmpty ? '($roomNumber)' : ''}'
                                  : 'Room: Pending Assignment',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. Stay Dates
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Check-in: $checkIn',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Check-out: $checkOut',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}