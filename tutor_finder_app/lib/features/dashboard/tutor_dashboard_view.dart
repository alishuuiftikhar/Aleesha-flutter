import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/booking_model.dart';
import 'manage_tutor_profile_screen.dart';

class TutorDashboardView extends StatefulWidget {
  const TutorDashboardView({super.key});

  @override
  State<TutorDashboardView> createState() => TutorDashboardViewState();
}

class TutorDashboardViewState extends State<TutorDashboardView> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      
      final bookings = await service.getMyBookings(user.id, true);
      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Dashboard Load Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookings: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _updateBooking(String id, String status) async {
    setState(() => _isLoading = true);
    try {
      await context.read<SupabaseService>().updateBookingStatus(id, status);
      loadBookings();
      if (mounted) {
        String message = '';
        Color bgColor = Colors.grey;
        if (status == 'confirmed') {
          message = 'Booking Approved Successfully!';
          bgColor = Colors.green;
        } else if (status == 'cancelled') {
          message = 'Booking Rejected/Cancelled.';
          bgColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: bgColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // AB HUM SIRF PENDING NAHI, BALKE SAARI BOOKINGS DEKHENGE TAQY KOI MISS NA HO
    final pendingBookings = _bookings.where((b) => b.status.toLowerCase() == 'pending').toList();
    final otherBookings = _bookings.where((b) => b.status.toLowerCase() != 'pending').toList();

    // Widget list ko pehle hi bana letay hain taqy koi confusion na ho
    List<Widget> dashboardItems = [];
    dashboardItems.add(_buildStatCards());
    dashboardItems.add(const SizedBox(height: 24));
    dashboardItems.add(Text(
      'Booking Requests (${pendingBookings.length})', 
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
    ));
    dashboardItems.add(const SizedBox(height: 12));

    if (pendingBookings.isNotEmpty) {
      for (var booking in pendingBookings) {
        dashboardItems.add(_buildBookingRequestCard(booking));
      }
    } else if (_bookings.isNotEmpty) {
      dashboardItems.add(const Center(child: Text('No new requests, but you have total classes below.')));
    } else if (!_isLoading) {
      dashboardItems.add(const Center(child: Text('No bookings found.')));
    }

    if (otherBookings.isNotEmpty) {
      dashboardItems.add(const SizedBox(height: 32));
      dashboardItems.add(const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
      dashboardItems.add(const SizedBox(height: 12));
      for (var b in otherBookings.take(10)) {
        dashboardItems.add(Card(
          child: ListTile(
            title: Text(b.subject?.name ?? 'Class'),
            subtitle: Text('Status: ${b.status}'),
            trailing: Text(b.bookingDate.toString().split(' ')[0]),
          ),
        ));
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => loadBookings(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Tutor Dashboard'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageTutorProfileScreen()),
                        ).then((_) => loadBookings());
                      },
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(dashboardItems),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading && _bookings.isEmpty)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _statCard('Total Earnings', '\$${_calculateEarnings()}', Icons.attach_money)),
            const SizedBox(width: 16),
            Expanded(child: _statCard('Active Classes', '${_bookings.where((b) => b.status == 'confirmed').length}', Icons.book)),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Note: Only classes with "Confirmed" status are counted as active.',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  double _calculateEarnings() {
    return _bookings
        .where((b) => b.status == 'completed')
        .fold(0.0, (sum, b) => sum + b.totalPrice);
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBookingRequestCard(BookingModel booking) {
    // Null safety ke liye default values
    final subjectName = booking.subject?.name ?? 'General Class';
    final dateStr = booking.bookingDate.toIso8601String().split('T')[0];
    final timeStr = booking.startTime;
    final studentName = booking.studentName ?? 'Unknown Student';
    final studentPhone = booking.studentPhone ?? 'No Phone';
    final fee = booking.totalPrice.toStringAsFixed(2);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                  ),
                ),
                Text(
                  '\$$fee',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Student: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(studentName),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Phone: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(studentPhone),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Schedule: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$dateStr at $timeStr'),
              ],
            ),
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Note: ${booking.notes}',
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateBooking(booking.id, 'cancelled'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateBooking(booking.id, 'confirmed'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
