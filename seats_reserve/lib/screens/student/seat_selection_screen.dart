import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/models/seat.dart';

import 'package:seats_reserve/widgets/interactive_seat_map.dart';
import 'package:seats_reserve/widgets/reservation_countdown.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int? selectedSeatId;

  void _reserveSeat(String seatNumber) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reservation'),
        content: Text('Reserve $seatNumber for today?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
        ],
      ),
    );

    if (confirm != true) return;
    
    final auth = context.read<AuthProvider>();
    final data = context.read<DataProvider>();
    
    try {
      await data.reserveSeat(auth.userProfile!.id, selectedSeatId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seat reserved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reserve seat: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final myRes = data.myTodayReservation;
    
    final now = DateTime.now();
    final deadlineStr = data.settings?.reservationDeadline ?? '10:00:00';
    final parts = deadlineStr.split(':');
    final deadline = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    final isAfterDeadline = now.isAfter(deadline);
    final canReserve = myRes == null && !isAfterDeadline;

    return Scaffold(
      appBar: AppBar(title: const Text('Select a Seat')),
      body: Column(
        children: [
          if (data.settings != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReservationCountdown(
                deadlineStr: data.settings!.reservationDeadline,
                serverTime: data.serverTime ?? DateTime.now(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegend(Colors.green, 'Available'),
                _buildLegend(Colors.orange, 'Reserved'),
                _buildLegend(Colors.red, 'Occupied'),
                _buildLegend(Colors.grey[300]!, 'Disabled'),
                _buildLegend(AppTheme.primaryColor, 'Selected'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: InteractiveSeatMap(
              seats: data.seats,
              todayReservations: data.todayReservations,
              selectedSeatId: selectedSeatId,
              onSeatTap: (id) => setState(() => selectedSeatId = id),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (selectedSeatId == null || !canReserve) 
                ? null 
                : () {
                    final seat = data.seats.firstWhere((s) => s.id == selectedSeatId);
                    _reserveSeat(seat.seatNumber);
                  },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                myRes != null 
                  ? 'Already Reserved' 
                  : isAfterDeadline 
                    ? 'Reservation Closed' 
                    : 'Confirm Reservation',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
