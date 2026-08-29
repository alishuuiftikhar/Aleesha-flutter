import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const PackingApp());
}

// --- Colors ---
class AppColors {
  static const Color mainBg = Color(0xFFFFF3D6);
  static const Color secondaryBg = Color(0xFFFFE4A8);
  static const Color cardBg = Color(0xFFFFFAED);
  static const Color primary = Color(0xFFC2410C);
  static const Color secondary = Color(0xFFEA580C);
  static const Color accent = Color(0xFF2563EB);
  static const Color text = Color(0xFF40210F);
}

// --- Models ---
class PackingItem {
  String id;
  String name;
  bool isPacked;

  PackingItem({required this.id, required this.name, this.isPacked = false});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'isPacked': isPacked};
  factory PackingItem.fromJson(Map<String, dynamic> json) => PackingItem(
        id: json['id'],
        name: json['name'],
        isPacked: json['isPacked'],
      );
}

class PackingCategory {
  String id;
  String name;
  IconData icon;
  List<PackingItem> items;

  PackingCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon.codePoint,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory PackingCategory.fromJson(Map<String, dynamic> json) => PackingCategory(
        id: json['id'],
        name: json['name'],
        icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
        items: (json['items'] as List).map((e) => PackingItem.fromJson(e)).toList(),
      );
}

class Trip {
  String id;
  String destination;
  DateTime startDate;
  DateTime endDate;
  List<PackingCategory> categories;

  Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.categories,
  });

  double get packingProgress {
    int total = 0;
    int packed = 0;
    for (var cat in categories) {
      total += cat.items.length;
      packed += cat.items.where((i) => i.isPacked).length;
    }
    return total == 0 ? 0.0 : packed / total;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'destination': destination,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'categories': categories.map((e) => e.toJson()).toList(),
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'],
        destination: json['destination'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        categories: (json['categories'] as List).map((e) => PackingCategory.fromJson(e)).toList(),
      );
}

// --- Data Manager ---
class TripManager {
  static final TripManager _instance = TripManager._internal();
  factory TripManager() => _instance;
  TripManager._internal();

  List<Trip> trips = [];

  Future<void> load() async {
    trips = await StorageService.loadTrips();
  }

  Future<void> save() async {
    await StorageService.saveTrips(trips);
  }

  void addTrip(Trip trip) {
    trips.add(trip);
    save();
  }

  void deleteTrip(String id) {
    trips.removeWhere((t) => t.id == id);
    save();
  }
}

// --- Storage Service ---
class StorageService {
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/trips.json');
  }

  static Future<List<Trip>> loadTrips() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((e) => Trip.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTrips(List<Trip> trips) async {
    final file = await _localFile;
    final jsonString = json.encode(trips.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}

// --- Main App ---
class PackingApp extends StatelessWidget {
  const PackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Pack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.mainBg,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.text),
          bodyMedium: TextStyle(color: AppColors.text),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// --- Splash Screen ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await TripManager().load();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.luggage, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'TRAVEL PACK',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// --- Home Page ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  List<Trip> get filteredTrips {
    final trips = TripManager().trips;
    if (searchQuery.isEmpty) return trips;
    return trips.where((t) => t.destination.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
        backgroundColor: AppColors.secondaryBg,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.text),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search trips...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Expanded(
            child: filteredTrips.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: AppColors.primary.withOpacity(0.3)),
                        const SizedBox(height: 10),
                        const Text('No trips found. Add one!', style: TextStyle(color: AppColors.text)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return _TripCard(
                        trip: trip,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TripDetailPage(trip: trip)),
                          );
                          setState(() {}); // Refresh progress
                        },
                        onDelete: () {
                          setState(() => TripManager().deleteTrip(trip.id));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final newTrip = await Navigator.push<Trip>(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTripPage()),
          );
          if (newTrip != null) {
            setState(() => TripManager().addTrip(newTrip));
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TripCard({required this.trip, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Text(
          trip.destination,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.text),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, y').format(trip.endDate)}',
                  style: const TextStyle(color: AppColors.text),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: trip.packingProgress,
              backgroundColor: AppColors.secondaryBg,
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 4),
            Text(
              '${(trip.packingProgress * 100).toInt()}% Packed',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accent),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Trip?'),
                content: const Text('Are you sure you want to remove this trip?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  TextButton(onPressed: () {
                    Navigator.pop(ctx);
                    onDelete();
                  }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- Add/Edit Trip Page ---
class AddEditTripPage extends StatefulWidget {
  final Trip? trip;
  const AddEditTripPage({super.key, this.trip});

  @override
  State<AddEditTripPage> createState() => _AddEditTripPageState();
}

class _AddEditTripPageState extends State<AddEditTripPage> {
  final _destController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _destController.text = widget.trip!.destination;
      _startDate = widget.trip!.startDate;
      _endDate = widget.trip!.endDate;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) _endDate = _startDate.add(const Duration(days: 1));
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip == null ? 'Create Trip' : 'Edit Trip'),
        backgroundColor: AppColors.secondaryBg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _destController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.flight_takeoff),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Departure Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
              onTap: () => _selectDate(context, true),
              tileColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Return Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_endDate)),
              onTap: () => _selectDate(context, false),
              tileColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                onPressed: () {
                  if (_destController.text.isEmpty) return;
                  final trip = Trip(
                    id: widget.trip?.id ?? const Uuid().v4(),
                    destination: _destController.text,
                    startDate: _startDate,
                    endDate: _endDate,
                    categories: widget.trip?.categories ?? _getDefaultCategories(),
                  );
                  Navigator.pop(context, trip);
                },
                child: const Text('SAVE TRIP', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PackingCategory> _getDefaultCategories() {
    return [
      PackingCategory(id: 'c1', name: 'Clothing', icon: Icons.checkroom, items: [
        PackingItem(id: 'i1', name: 'T-shirts'),
        PackingItem(id: 'i2', name: 'Underwear'),
        PackingItem(id: 'i3', name: 'Socks'),
        PackingItem(id: 'i4', name: 'Pants/Jeans'),
      ]),
      PackingCategory(id: 'c2', name: 'Electronics', icon: Icons.devices, items: [
        PackingItem(id: 'i5', name: 'Phone Charger'),
        PackingItem(id: 'i6', name: 'Power Bank'),
        PackingItem(id: 'i7', name: 'Headphones'),
      ]),
      PackingCategory(id: 'c3', name: 'Documents', icon: Icons.description, items: [
        PackingItem(id: 'i8', name: 'Passport'),
        PackingItem(id: 'i9', name: 'Flight Tickets'),
        PackingItem(id: 'i10', name: 'Hotel Booking'),
      ]),
      PackingCategory(id: 'c4', name: 'Toiletries', icon: Icons.sanitizer, items: [
        PackingItem(id: 'i11', name: 'Toothbrush'),
        PackingItem(id: 'i12', name: 'Toothpaste'),
        PackingItem(id: 'i13', name: 'Deodorant'),
      ]),
      PackingCategory(id: 'c5', name: 'Custom', icon: Icons.add_box, items: []),
    ];
  }
}

// --- Trip Detail / Checklist Page ---
class TripDetailPage extends StatefulWidget {
  final Trip trip;
  const TripDetailPage({super.key, required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  String searchQuery = '';

  void _addItem(PackingCategory category) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add to ${category.name}'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Item name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  category.items.add(PackingItem(id: const Uuid().v4(), name: controller.text));
                });
                TripManager().save();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _resetChecklist() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Checklist?'),
        content: const Text('This will unmark all items as unpacked.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                for (var cat in widget.trip.categories) {
                  for (var item in cat.items) {
                    item.isPacked = false;
                  }
                }
              });
              TripManager().save();
              Navigator.pop(ctx);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.destination, style: const TextStyle(color: AppColors.text)),
        backgroundColor: AppColors.secondaryBg,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.text), onPressed: _resetChecklist),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.text),
            onPressed: () async {
              final updated = await Navigator.push<Trip>(
                context,
                MaterialPageRoute(builder: (context) => AddEditTripPage(trip: widget.trip)),
              );
              if (updated != null) {
                setState(() {
                  widget.trip.destination = updated.destination;
                  widget.trip.startDate = updated.startDate;
                  widget.trip.endDate = updated.endDate;
                });
                TripManager().save();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.secondaryBg.withOpacity(0.5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Packing Progress', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
                    Text('${(widget.trip.packingProgress * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.trip.packingProgress,
                  color: AppColors.accent,
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.trip.categories.length,
              itemBuilder: (context, catIndex) {
                final category = widget.trip.categories[catIndex];
                final filteredItems = category.items
                    .where((i) => i.name.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();
                
                if (searchQuery.isNotEmpty && filteredItems.isEmpty) return const SizedBox.shrink();

                return ExpansionTile(
                  leading: Icon(category.icon, color: AppColors.primary),
                  title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
                  subtitle: Text('${category.items.where((i) => i.isPacked).length}/${category.items.length} items'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.secondary),
                    onPressed: () => _addItem(category),
                  ),
                  children: filteredItems.map((item) {
                    return ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isPacked ? TextDecoration.lineThrough : null,
                          color: item.isPacked ? Colors.grey : AppColors.text,
                        ),
                      ),
                      leading: Checkbox(
                        activeColor: AppColors.accent,
                        value: item.isPacked,
                        onChanged: (val) {
                          setState(() => item.isPacked = val!);
                          TripManager().save();
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep, size: 20, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            category.items.removeWhere((i) => i.id == item.id);
                          });
                          TripManager().save();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Settings Page ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: AppColors.secondaryBg),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Manage your account'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Travel reminders'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_upload),
            title: Text('Backup Data'),
            subtitle: Text('Sync with cloud (Coming Soon)'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Travel Pack Checklist',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.luggage, color: AppColors.primary),
              );
            },
          ),
        ],
      ),
    );
  }
}
