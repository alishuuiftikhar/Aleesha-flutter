import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/booking_provider.dart';
import 'bus_list_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fromCity;
  String? toCity;
  DateTime selectedDate = DateTime(2026, 8, 28);
  final List<String> cities = ['New York', 'Boston', 'Washington', 'Philadelphia', 'Chicago'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('TravelEase Bus'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.primary, size: 35)),
                  SizedBox(height: 10),
                  Text('Welcome, Traveler!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: const Text('My Bookings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primary),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=1000'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(AppColors.primary.withOpacity(0.7), BlendMode.srcOver),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bus, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Where would you like to go?',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black45)]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'From',
                          prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
                        ),
                        value: fromCity,
                        items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                        onChanged: (val) => setState(() => fromCity = val),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'To',
                          prefixIcon: Icon(Icons.my_location, color: AppColors.accent),
                        ),
                        value: toCity,
                        items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                        onChanged: (val) => setState(() => toCity = val),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2027),
                          );
                          if (picked != null) setState(() => selectedDate = picked);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Departure Date',
                            prefixIcon: Icon(Icons.calendar_today, color: AppColors.secondary),
                          ),
                          child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (fromCity == null || toCity == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select cities')),
                              );
                              return;
                            }
                            if (fromCity == toCity) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Source and destination cannot be same')),
                              );
                              return;
                            }
                            
                            final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                            Provider.of<BookingProvider>(context, listen: false).searchBuses(fromCity!, toCity!, dateStr);
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BusListScreen(from: fromCity!, to: toCity!, date: dateStr)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('SEARCH BUSES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  _offerCard('20% OFF', 'Use code TRAVEL20', Colors.orange),
                  _offerCard('FREE SNACKS', 'On sleeper buses', Colors.teal),
                  _offerCard('CASHBACK', 'Up to \$10 back', Colors.blueGrey),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _offerCard(String title, String subtitle, Color color) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: AppColors.text)),
        ],
      ),
    );
  }
}
