import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';
import 'package:intl/intl.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _dbHelper.rawQuery('''
      SELECT s.*, v.plate_number, v.vehicle_type, sp.space_number 
      FROM parking_sessions s
      JOIN vehicles v ON s.vehicle_id = v.id
      JOIN parking_spaces sp ON s.space_id = sp.id
      ORDER BY s.check_in_time DESC
    ''');
    setState(() {
      _sessions = data;
      _isLoading = false;
    });
  }

  Future<void> _checkOut(Map<String, dynamic> session) async {
    final checkInTime = DateTime.parse(session['check_in_time']);
    final checkOutTime = DateTime.now();
    final duration = checkOutTime.difference(checkInTime);
    
    // Simple logic: $5 per hour, minimum $5
    double hours = duration.inMinutes / 60;
    if (hours < 1) hours = 1;
    double fee = hours * 5.0;

    await _dbHelper.update('parking_sessions', {
      'check_out_time': checkOutTime.toIso8601String(),
      'total_fee': fee,
      'status': 'completed',
    }, 'id = ?', [session['id']]);

    await _dbHelper.update('parking_spaces', {'is_occupied': 0}, 'id = ?', [session['space_id']]);

    // Record payment
    await _dbHelper.insert('payments', {
      'session_id': session['id'],
      'amount': fee,
      'payment_date': checkOutTime.toIso8601String(),
      'payment_method': 'Cash',
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Checked Out! Duration: ${hours.toStringAsFixed(1)}h. Fee: \$${fee.toStringAsFixed(2)}'),
      backgroundColor: Colors.orange,
    ));
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Parking History', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: _sessions.length,
            itemBuilder: (context, index) {
              final session = _sessions[index];
              final isActive = session['status'] == 'active';
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(session['plate_number'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(isActive ? 'ACTIVE' : 'COMPLETED', style: TextStyle(color: isActive ? Colors.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 5),
                          Text('Space: ${session['space_number']}', style: const TextStyle(color: AppColors.text)),
                          const Spacer(),
                          const Icon(Icons.timer, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 5),
                          Text(DateFormat('MMM dd, HH:mm').format(DateTime.parse(session['check_in_time'])), style: const TextStyle(color: AppColors.text)),
                        ],
                      ),
                      if (!isActive) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fee: \$${session['total_fee'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                            Text('Out: ${DateFormat('HH:mm').format(DateTime.parse(session['check_out_time']))}', style: const TextStyle(color: AppColors.secondary)),
                          ],
                        ),
                      ],
                      if (isActive) ...[
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _checkOut(session),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: const Text('Check Out Now', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
