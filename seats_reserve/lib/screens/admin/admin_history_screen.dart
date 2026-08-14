import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class AdminHistoryScreen extends StatefulWidget {
  const AdminHistoryScreen({super.key});

  @override
  State<AdminHistoryScreen> createState() => _AdminHistoryScreenState();
}

class _AdminHistoryScreenState extends State<AdminHistoryScreen> {
  String _searchQuery = '';
  String _statusFilter = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    
    // Using todayReservations as base for now, but in reality we'd fetch all history
    // Since DataProvider has reportReservations, we can use that for history if we fetch it correctly
    final history = data.reportReservations.where((res) {
      bool matchesSearch = res.student?.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? true;
      bool matchesStatus = _statusFilter == 'all' || res.status.toLowerCase() == _statusFilter.toLowerCase();
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('📜 Reservation History')),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search student or ID...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _statusChip('all', 'All'),
                      const SizedBox(width: 8),
                      _statusChip('present', 'Present'),
                      const SizedBox(width: 8),
                      _statusChip('absent', 'Absent'),
                      const SizedBox(width: 8),
                      _statusChip('reserved', 'Reserved'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: history.isEmpty 
              ? const Center(child: Text('No matching records found.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final res = history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(res.seat?.seatNumber.replaceAll('Seat ', '') ?? '')),
                        title: Text(res.student?.fullName ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${res.student?.studentId} | ${DateFormat('dd MMM').format(res.reservationDate)}'),
                            Text('Time: ${DateFormat('hh:mm a').format(res.reservedAt)}'),
                          ],
                        ),
                        trailing: _statusLabel(res.status),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String id, String label) {
    final isSelected = _statusFilter == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => setState(() => _statusFilter = id),
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 11),
    );
  }

  Widget _statusLabel(String status) {
    Color color = Colors.grey;
    if (status == 'present') color = Colors.green;
    if (status == 'absent') color = Colors.red;
    if (status == 'reserved') color = Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
