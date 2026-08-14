import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class DailyReservationsScreen extends StatelessWidget {
  const DailyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final reservations = data.todayReservations;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reservations')),
      body: reservations.isEmpty
          ? const Center(child: Text('No reservations for today.'))
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final res = reservations[index];
                final student = res.student;
                final seat = res.seat;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(seat?.seatNumber.replaceAll('Seat ', '') ?? '??', 
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text(student?.fullName ?? 'Unknown Student'),
                    subtitle: Text('Status: ${res.status}'),
                    trailing: res.status == 'reserved'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () => data.markAttendance(res.id, 'present', 0),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => data.markAttendance(res.id, 'absent', data.settings?.fineAmount ?? 200),
                              ),
                            ],
                          )
                        : Icon(
                            res.status == 'present' ? Icons.check_circle : Icons.cancel,
                            color: res.status == 'present' ? Colors.green : Colors.red,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
