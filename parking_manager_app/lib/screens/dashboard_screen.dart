import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';
import 'vehicle_registration_screen.dart';
import 'check_in_screen.dart';
import 'parking_history_screen.dart';
import 'parking_lots_screen.dart';
import 'vehicles_list_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalSpaces = 0;
  int occupiedSpaces = 0;
  double dailyRevenue = 0.0;
  List<Map<String, dynamic>> _recentSessions = [];
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final spaces = await _dbHelper.queryAll('parking_spaces');
    final revenueResult = await _dbHelper.rawQuery("SELECT SUM(amount) as revenue FROM payments WHERE DATE(payment_date) = DATE('now')");
    final recentSessions = await _dbHelper.rawQuery('''
      SELECT s.*, v.plate_number 
      FROM parking_sessions s
      JOIN vehicles v ON s.vehicle_id = v.id
      ORDER BY s.check_in_time DESC
      LIMIT 3
    ''');
    
    setState(() {
      totalSpaces = spaces.length;
      occupiedSpaces = spaces.where((s) => s['is_occupied'] == 1).length;
      dailyRevenue = (revenueResult.first['revenue'] ?? 0.0).toDouble();
      _recentSessions = recentSessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 25),
            _buildStatsGrid(),
            const SizedBox(height: 30),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 15),
            _buildQuickActions(context),
            const SizedBox(height: 30),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accent,
            child: Icon(Icons.person, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome Back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('Admin Manager', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Spaces', totalSpaces.toString(), Icons.local_parking, Colors.blue),
        _buildStatCard('Occupied', occupiedSpaces.toString(), Icons.directions_car, Colors.red),
        _buildStatCard('Available', (totalSpaces - occupiedSpaces).toString(), Icons.check_circle, Colors.green),
        _buildStatCard('Today Revenue', '\$${dailyRevenue.toStringAsFixed(2)}', Icons.payments, AppColors.accent),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
            ],
          ),
          Text(title, style: const TextStyle(fontSize: 14, color: AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 2.5,
      children: [
        _buildActionButton(context, 'Check In', Icons.login, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInScreen())).then((_) => _loadStats());
        }),
        _buildActionButton(context, 'Register', Icons.app_registration, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleRegistrationScreen()));
        }),
        _buildActionButton(context, 'Vehicles', Icons.list, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const VehiclesListScreen()));
        }),
        _buildActionButton(context, 'Lots', Icons.layers, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingLotsScreen()));
        }),
        _buildActionButton(context, 'History', Icons.history, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingHistoryScreen()));
        }),
        _buildActionButton(context, 'Stats', Icons.bar_chart, AppColors.secondary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()));
        }),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
        ),
        const SizedBox(height: 10),
        _recentSessions.isEmpty
            ? Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(15)),
                child: const Center(child: Text('No recent activity', style: TextStyle(color: AppColors.secondary))),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentSessions.length,
                itemBuilder: (context, index) {
                  final session = _recentSessions[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: session['status'] == 'active' ? Colors.green : Colors.grey,
                        child: const Icon(Icons.history, color: Colors.white, size: 20),
                      ),
                      title: Text(session['plate_number'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(session['status'].toString().toUpperCase()),
                      trailing: Text(session['check_in_time'].toString().substring(11, 16)),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
