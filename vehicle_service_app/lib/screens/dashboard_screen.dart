import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vehicle.dart';
import '../models/reminder.dart';
import '../theme.dart';
import 'vehicle_list_screen.dart';
import 'settings_screen.dart';
import 'vehicle_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Vehicle> _vehicles = [];
  List<Reminder> _reminders = [];
  double _totalCost = 0;
  int _totalServices = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final vehicles = await DatabaseHelper.instance.readAllVehicles();
    List<Reminder> allReminders = [];
    double total = 0;
    int serviceCount = 0;

    for (var vehicle in vehicles) {
      final reminders = await DatabaseHelper.instance.readReminders(vehicle.id!);
      allReminders.addAll(reminders);

      final records = await DatabaseHelper.instance.readServiceRecords(vehicle.id!);
      serviceCount += records.length;
      for (var record in records) {
        total += record.cost;
      }
    }

    setState(() {
      _vehicles = vehicles;
      _reminders = allReminders;
      _totalCost = total;
      _totalServices = serviceCount;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildDashboardView(),
      const VehicleListScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Service Pro', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Active Reminders', style: Theme.of(context).textTheme.titleLarge),
              IconButton(icon: const Icon(Icons.info_outline, size: 20), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 8),
          _reminders.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No active reminders. Add a vehicle or service to get started!'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = _reminders[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active, color: AppColors.accent),
                        title: Text(reminder.title, overflow: TextOverflow.ellipsis),
                        subtitle: Text('Due: ${reminder.dueDate.toLocal().toString().split(' ')[0]}'),
                        trailing: Checkbox(
                          value: reminder.isCompleted,
                          onChanged: (val) async {
                            final updated = Reminder(
                              id: reminder.id,
                              vehicleId: reminder.vehicleId,
                              title: reminder.title,
                              dueDate: reminder.dueDate,
                              dueMileage: reminder.dueMileage,
                              isCompleted: val ?? false,
                            );
                            await DatabaseHelper.instance.updateReminder(updated);
                            _loadData();
                          },
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Vehicles', style: Theme.of(context).textTheme.titleLarge),
              TextButton(onPressed: () => _onItemTapped(1), child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          _vehicles.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('No vehicles added yet.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _onItemTapped(1),
                          child: const Text('Add Vehicle'),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _vehicles[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VehicleDetailScreen(vehicle: vehicle)),
                        ).then((_) => _loadData()),
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    vehicle.imageUrl ?? 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=500&q=80',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.directions_car, size: 50)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('${vehicle.make} ${vehicle.model}', style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: AppColors.secondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSummaryItem('Vehicles', _vehicles.length.toString(), Icons.directions_car, onTap: () => _onItemTapped(1))),
                Expanded(child: _buildSummaryItem('Services', _totalServices.toString(), Icons.build, onTap: () => _onItemTapped(1))),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildSummaryItem('Reminders', _reminders.length.toString(), Icons.notifications)),
                Expanded(child: _buildSummaryItem('Total Cost', '\$${_totalCost.toStringAsFixed(0)}', Icons.attach_money)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.text), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
