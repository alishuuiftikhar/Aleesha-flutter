import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => MyBookingsScreenState();
}

class MyBookingsScreenState extends State<MyBookingsScreen> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      
      final profile = await service.getProfile(user.id);
      final isTutor = profile?.role == 'tutor';
      final bookings = await service.getMyBookings(user.id, isTutor);
      
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Bookings Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Classes'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: [
              Tab(text: 'Pending Requests'),
              Tab(text: 'History / Approved'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: $_errorMessage'),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: loadBookings, child: const Text('Retry')),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => loadBookings(),
                    child: TabBarView(
                      children: [
                        // Tab 1: Sirf Pending requests dikhao
                        _buildBookingList(_bookings.where((b) => b.status.toLowerCase() == 'pending').toList()),
                        // Tab 2: Confirmed (Approved), Completed aur Cancelled yahan dikhao
                        _buildBookingList(_bookings.where((b) => b.status.toLowerCase() != 'pending').toList()),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Center(child: Text('No records found in this section.', style: TextStyle(color: Colors.grey))),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              booking.subject?.name ?? 'General Class',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Tutor: ${booking.tutor?.fullName ?? 'N/A'}', style: const TextStyle(color: AppColors.primary)),
                Text('Date: ${DateFormat('MMM d, yyyy').format(booking.bookingDate)}'),
                Text('Time: ${booking.startTime}'),
              ],
            ),
            trailing: _buildStatusBadge(booking.status),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label = status.toUpperCase();
    
    switch (status.toLowerCase()) {
      case 'confirmed': 
        color = Colors.green; 
        label = 'APPROVED';
        break;
      case 'pending': 
        color = Colors.orange; 
        break;
      case 'cancelled': 
        color = Colors.red; 
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default: 
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
