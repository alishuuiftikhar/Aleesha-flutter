import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_model.dart'; // <-- Aapki admin_model.dart file
import 'add_hotel_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseClient _supabase = Supabase.instance.client;

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

  // 1. Delete Hotel Logic
  Future<void> _deleteHotel(String id) async {
    try {
      await _supabase.from('hotels').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel delete ho gaya!')),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete Error: $e')),
        );
      }
    }
  }

  // 2. Edit Hotel Dialog Logic
  void _editHotelDialog(Hotel hotel) {
    final nameCtrl = TextEditingController(text: hotel.name);
    final cityCtrl = TextEditingController(text: hotel.city);
    final addressCtrl = TextEditingController(text: hotel.address);
    final descCtrl = TextEditingController(text: hotel.description);
    final imageCtrl = TextEditingController(text: hotel.imageUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Hotel Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Hotel Name')),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City')),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'Image URL')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _supabase.from('hotels').update({
                'name': nameCtrl.text.trim(),
                'city': cityCtrl.text.trim(),
                'address': addressCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'image_url': imageCtrl.text.trim(),
              }).eq('id', hotel.id);

              if (mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hotel info update ho gayi!')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // 3. Assign Room & Approve Booking Dialog Logic
  void _showAssignRoomDialog(Map<String, dynamic> booking) {
    final roomController = TextEditingController(text: booking['assigned_room'] ?? '');
    final priceController = TextEditingController(text: booking['total_price']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Assign Room for ${booking['guest_name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: roomController,
              decoration: const InputDecoration(
                labelText: "Room Number / Type (e.g. Room 204 - Deluxe)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Amount (PKR)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (roomController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pehle Room Number fill karein!")),
                );
                return;
              }

              await _supabase.from('bookings').update({
                'assigned_room': roomController.text.trim(),
                'total_price': double.tryParse(priceController.text.trim()) ?? 0,
                'status': 'Approved',
              }).eq('id', booking['id']);

              if (mounted) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Booking Approved and Room Assigned Successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text("Approve & Assign Room"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.hotel), text: 'Hotels History'),
            Tab(icon: Icon(Icons.book_online), text: 'User Requests'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F4C81),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHotelScreen()),
          );
          setState(() {});
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // -------------------------------------------------------------
          // TAB 1: SAVED HOTELS HISTORY (Edit & Delete Features)
          // -------------------------------------------------------------
          FutureBuilder<List<dynamic>>(
            future: _supabase.from('hotels').select().order('created_at', ascending: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Koi hotel add nahi hua.'));
              }

              final hotels = snapshot.data!.map((json) => Hotel.fromJson(json)).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty)
                            ? NetworkImage(hotel.imageUrl!)
                            : null,
                        child: (hotel.imageUrl == null || hotel.imageUrl!.isEmpty)
                            ? const Icon(Icons.hotel)
                            : null,
                      ),
                      title: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${hotel.city} • ${hotel.address}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editHotelDialog(hotel),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteHotel(hotel.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // -------------------------------------------------------------
          // TAB 2: USER BOOKINGS REQUESTS (Room Assigning & Approval)
          // -------------------------------------------------------------
          FutureBuilder<List<dynamic>>(
            future: _supabase
                .from('bookings')
                .select('*, hotels(name)')
                .order('created_at', ascending: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Abhi tak koi booking request nahi aayi.'));
              }

              final bookings = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];
                  final hotelName = b['hotels'] != null ? b['hotels']['name'] : 'Hotel';
                  final isApproved = b['status'] == 'Approved';

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${b['guest_name']} ($hotelName)",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isApproved ? Colors.green.shade100 : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  b['status'] ?? 'Pending',
                                  style: TextStyle(
                                    color: isApproved ? Colors.green.shade900 : Colors.orange.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text("Phone: ${b['guest_phone']}"),
                          Text("Dates: ${b['check_in']} to ${b['check_out']}"),
                          Text("Guests: ${b['guests_count'] ?? 1}"),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  isApproved
                                      ? "Room: ${b['assigned_room']} (PKR ${b['total_price']})"
                                      : "Room: Not Assigned Yet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isApproved ? Colors.green.shade800 : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApproved ? Colors.orange : const Color(0xFF0F4C81),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => _showAssignRoomDialog(b),
                                child: Text(isApproved ? "Edit Room" : "Assign Room"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}