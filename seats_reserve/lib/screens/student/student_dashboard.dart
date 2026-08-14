import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/screens/student/notifications_screen.dart';
import 'package:seats_reserve/screens/student/seat_selection_screen.dart';
import 'package:seats_reserve/screens/student/register_new_student_screen.dart';
import 'package:seats_reserve/screens/student/my_added_students_screen.dart';
import 'package:seats_reserve/screens/student/my_attendance_screen.dart';
import 'package:seats_reserve/screens/student/my_fines_screen.dart';
import 'package:seats_reserve/screens/student/my_reservations_screen.dart';
import 'package:seats_reserve/screens/announcements_screen.dart';
import 'package:seats_reserve/widgets/reservation_countdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seats_reserve/models/reservation.dart';
import 'package:seats_reserve/models/announcement.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().userProfile;
    final data = context.watch<DataProvider>();
    final isLoading = data.isLoading;
    
    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final totalSeats = data.settings?.totalSeats ?? 0;
    final reservedCount = data.todayReservations.length;
    final availableSeats = totalSeats - reservedCount;
    final myRes = data.myTodayReservation;
    final myFines = data.myFines.where((f) => f.status == 'unpaid').fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.settings?.houseName ?? 'SeatSync', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            Text('Welcome, ${profile.fullName.split(' ')[0]} 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => data.fetchInitialData(profile.id, profile.role),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => data.fetchInitialData(profile.id, profile.role),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Statistics (Compact Row)
              Row(
                children: [
                  _buildSmallStat('Total Seats', isLoading ? '...' : totalSeats.toString(), Icons.event_seat, AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  _buildSmallStat('Available', isLoading ? '...' : availableSeats.toString(), Icons.check_circle, Colors.green),
                  const SizedBox(width: 12),
                  _buildSmallStat('My Fine', isLoading ? '...' : 'Rs. ${myFines.toInt()}', Icons.warning, Colors.orange),
                ],
              ),

              const SizedBox(height: 24),

              // 2. Quick Actions
              const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildActionIcon(context, 'Reserve', Icons.add_task, const SeatSelectionScreen()),
                  _buildActionIcon(context, 'History', Icons.history, const MyReservationsScreen()),
                  _buildActionIcon(context, 'Attendance', Icons.how_to_reg, const MyAttendanceScreen()),
                  _buildActionIcon(context, 'Fines', Icons.monetization_on, const MyFinesScreen()),
                ],
              ),

              const SizedBox(height: 12),
              Card(
                color: AppTheme.accentColor.withOpacity(0.1),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.person_add, color: AppTheme.accentColor, size: 20),
                  title: const Text('➕ Register New Student', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Register for admin approval', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterNewStudentScreen())),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Today's Reservation & Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today\'s Reservation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (data.settings != null)
                     _buildDeadlineBadge(data.settings!.reservationDeadline),
                ],
              ),
              const SizedBox(height: 12),
              if (myRes != null)
                _buildMyReservationCard(context, myRes, data)
              else
                _buildNoReservationCard(context, data),

              const SizedBox(height: 24),

              // 4. Latest Announcements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Announcements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                    child: const Text('View All'),
                  ),
                ],
              ),
              _buildAnnouncementPreview(data.announcements),

              const SizedBox(height: 24),

              // 5. Analytics (Attendance Summary)
              const Text('Attendance Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildAttendanceAnalytics(data.myAllReservations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineBadge(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final deadline = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    final isExpired = now.isAfter(deadline);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Deadline: $time',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isExpired ? Colors.red[900] : Colors.green[900],
        ),
      ),
    );
  }

  Widget _buildSmallStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context, String title, IconData icon, Widget screen) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
          child: CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildMyReservationCard(BuildContext context, Reservation res, DataProvider data) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white)),
        title: Text(res.seat?.seatNumber ?? 'Reserved'),
        subtitle: Text('Status: ${res.status.toUpperCase()}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(DateFormat('hh:mm a').format(res.reservedAt), style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text('Reserved', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoReservationCard(BuildContext context, DataProvider data) {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (data.settings != null)
              ReservationCountdown(deadlineStr: data.settings!.reservationDeadline, serverTime: data.serverTime ?? DateTime.now()),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeatSelectionScreen())),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
              child: const Text('Reserve a Seat Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementPreview(List<Announcement> list) {
    if (list.isEmpty) return const Text('No recent announcements', style: TextStyle(color: Colors.grey, fontSize: 12));
    return Column(
      children: list.take(2).map((a) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.campaign, color: Colors.orange, size: 20),
          title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text(a.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
        ),
      )).toList(),
    );
  }

  Widget _buildAttendanceAnalytics(List<Reservation> allRes) {
    final total = allRes.length;
    final present = allRes.where((r) => r.status == 'present').length;
    final absent = allRes.where((r) => r.status == 'absent').length;
    final rate = total == 0 ? 0 : (present / total * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: PieChart(PieChartData(sections: [
              PieChartSectionData(value: present.toDouble(), color: Colors.green, radius: 10, showTitle: false),
              PieChartSectionData(value: absent.toDouble(), color: Colors.red, radius: 10, showTitle: false),
              PieChartSectionData(value: (total - present - absent).toDouble(), color: Colors.grey[200]!, radius: 10, showTitle: false),
            ], centerSpaceRadius: 25)),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$rate%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const Text('Attendance Rate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _smallDot(Colors.green, 'Present: $present'),
                    const SizedBox(width: 12),
                    _smallDot(Colors.red, 'Absent: $absent'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _smallDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
