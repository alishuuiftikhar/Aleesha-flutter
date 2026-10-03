import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BikeRentalApp());
}

// Global Color Theme Colors
const Color kMainBg = Color(0xFFEAF4E2);
const Color kSecondaryBg = Color(0xFFD5E8C7);
const Color kCardBg = Color(0xFFF7FBF3);
const Color kPrimary = Color(0xFF386641);
const Color kSecondary = Color(0xFF6A994E);
const Color kAccent = Color(0xFFBC6C25);
const Color kText = Color(0xFF263B27);

class BikeRentalApp extends StatelessWidget {
  const BikeRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VeloRent Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kMainBg,
        primaryColor: kPrimary,
        colorScheme: const ColorScheme.light(
          primary: kPrimary,
          secondary: kSecondary,
          surface: kCardBg,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: kText,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 28),
          headlineMedium: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 22),
          titleLarge: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 18),
          bodyLarge: TextStyle(color: kText, fontSize: 16),
          bodyMedium: TextStyle(color: kText, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kCardBg,
          selectedItemColor: kPrimary,
          unselectedItemColor: kSecondary,
        ),
        cardTheme: CardThemeData(
          color: kCardBg,
          elevation: 1.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimary, kSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kCardBg.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_bike_outlined,
                size: 90,
                color: kCardBg,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'VeloRent Pro',
              style: TextStyle(
                color: kCardBg,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bicycle Rental & Inventory Management',
              style: TextStyle(
                color: kCardBg.withOpacity(0.9),
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kMainBg),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MAIN NAVIGATION CONTAINER ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Key to refresh states across tabs when necessary
  final GlobalKey<_DashboardTabState> _dashKey = GlobalKey();
  final GlobalKey<_BikesTabState> _bikesKey = GlobalKey();
  final GlobalKey<_RentalsTabState> _rentalsKey = GlobalKey();
  final GlobalKey<_CustomersTabState> _customersKey = GlobalKey();
  final GlobalKey<_SettingsStatsTabState> _statsKey = GlobalKey();

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Trigger refreshes as user taps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (index == 0) _dashKey.currentState?.loadData();
      if (index == 1) _bikesKey.currentState?.loadBikes();
      if (index == 2) _rentalsKey.currentState?.loadRentals();
      if (index == 3) _customersKey.currentState?.loadCustomers();
      if (index == 4) _statsKey.currentState?.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DashboardTab(
        key: _dashKey,
        onNavigateToBikes: () => _onTabChanged(1),
        onNavigateToRentals: () => _onTabChanged(2),
        onNavigateToCustomers: () => _onTabChanged(3),
      ),
      BikesTab(key: _bikesKey),
      RentalsTab(key: _rentalsKey),
      CustomersTab(key: _customersKey),
      SettingsStatsTab(key: _statsKey),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        backgroundColor: kCardBg,
        selectedItemColor: kPrimary,
        unselectedItemColor: kSecondary.withOpacity(0.6),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            activeIcon: Icon(Icons.directions_bike, color: kPrimary),
            label: 'Bikes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Rentals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Stats & More',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 1. DASHBOARD / HOME TAB
// ==========================================
class DashboardTab extends StatefulWidget {
  final VoidCallback onNavigateToBikes;
  final VoidCallback onNavigateToRentals;
  final VoidCallback onNavigateToCustomers;

  const DashboardTab({
    super.key,
    required this.onNavigateToBikes,
    required this.onNavigateToRentals,
    required this.onNavigateToCustomers,
  });

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Map<String, dynamic> _stats = {
    'totalEarnings': 0.0,
    'activeRentals': 0,
    'availableBikes': 0,
    'rentedBikes': 0,
    'maintenanceBikes': 0,
    'totalCustomers': 0
  };
  List<Map<String, dynamic>> _recentRentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    final stats = await DatabaseHelper.instance.getStatistics();
    final allRentals = await DatabaseHelper.instance.getAllRentals();
    setState(() {
      _stats = stats;
      _recentRentals = allRentals.take(3).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('VeloRent Pro Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : RefreshIndicator(
              onRefresh: loadData,
              color: kPrimary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kSecondaryBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kSecondary, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome Back, Manager!',
                            style: TextStyle(
                              color: kText,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage operations, track rental cycles, and inspect bicycle status effortlessly.',
                            style: TextStyle(
                              color: kText.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metrics Grid
                    Text('Overview Metrics', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        _buildMetricCard(
                          title: 'Total Revenue',
                          value: currencyFormat.format(_stats['totalEarnings']),
                          icon: Icons.monetization_on,
                          color: kPrimary,
                        ),
                        _buildMetricCard(
                          title: 'Active Rentals',
                          value: '${_stats['activeRentals']}',
                          icon: Icons.alarm,
                          color: kAccent,
                        ),
                        _buildMetricCard(
                          title: 'Bikes Available',
                          value: '${_stats['availableBikes']}',
                          icon: Icons.check_circle_outline,
                          color: Colors.green.shade700,
                        ),
                        _buildMetricCard(
                          title: 'In Maintenance',
                          value: '${_stats['maintenanceBikes']}',
                          icon: Icons.build_circle_outlined,
                          color: Colors.red.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Shortcuts
                    Text('Quick Action Shortcuts', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildShortcutButton(
                            label: 'Bikes',
                            icon: Icons.directions_bike,
                            onTap: widget.onNavigateToBikes,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildShortcutButton(
                            label: 'New Rental',
                            icon: Icons.add_circle_outline,
                            onTap: widget.onNavigateToRentals,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildShortcutButton(
                            label: 'Customers',
                            icon: Icons.people_alt_outlined,
                            onTap: widget.onNavigateToCustomers,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Active Rentals
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Rentals Feed', style: Theme.of(context).textTheme.titleLarge),
                        TextButton(
                          onPressed: widget.onNavigateToRentals,
                          child: const Text('View All', style: TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    _recentRentals.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: CardTheme.of(context).shape!.dashedBorder(), // simulated or standard clean container
                            child: const Center(
                              child: Text('No recent rentals registered yet.', style: TextStyle(color: kSecondary)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentRentals.length,
                            itemBuilder: (context, index) {
                              final rental = _recentRentals[index];
                              final start = DateTime.parse(rental['start_date']);
                              final end = DateTime.parse(rental['end_date']);
                              final formattedPeriod = "${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd').format(end)}";
                              
                              Color badgeColor = kAccent;
                              if (rental['status'] == 'Completed') badgeColor = kPrimary;
                              if (rental['status'] == 'Cancelled') badgeColor = Colors.grey;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: badgeColor.withOpacity(0.1),
                                    child: Icon(Icons.receipt_long, color: badgeColor),
                                  ),
                                  title: Text(
                                    rental['customer_name'] ?? 'Unknown Customer',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('$formattedPeriod • Total: \$${rental['total_price']}'),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      rental['status'],
                                      style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text('', style: TextStyle(color: color)), // alignment spacer
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kText),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: kText.withOpacity(0.6)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kSecondaryBg, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: kPrimary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kText),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

extension ShapeDashed on ShapeBorder {
  BoxDecoration dashedBorder() {
    return BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kSecondaryBg, style: BorderStyle.solid, width: 1),
    );
  }
}

// ==========================================
// 2. BIKE INVENTORY TAB (BIKES LIST, CATS, SEARCH, DETAILS)
// ==========================================
class BikesTab extends StatefulWidget {
  const BikesTab({super.key});

  @override
  State<BikesTab> createState() => _BikesTabState();
}

class _BikesTabState extends State<BikesTab> {
  List<Map<String, dynamic>> _allBikes = [];
  List<Map<String, dynamic>> _filteredBikes = [];
  bool _isLoading = true;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  final List<String> _categories = ['All', 'Mountain', 'Road', 'Hybrid', 'Electric', 'BMX'];
  final List<String> _statuses = ['All', 'Available', 'Rented', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    loadBikes();
  }

  Future<void> loadBikes() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllBikes();
    setState(() {
      _allBikes = data;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredBikes = _allBikes.where((bike) {
        final matchesSearch = bike['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            bike['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || bike['category'] == _selectedCategory;
        final matchesStatus = _selectedStatus == 'All' || bike['status'] == _selectedStatus;
        return matchesSearch && matchesCategory && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bicycle Fleet Inventory'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditBikeModal(),
        tooltip: 'Add Bike',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              onChanged: (val) {
                _searchQuery = val;
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search bike name or category...',
                hintStyle: TextStyle(color: kText.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: kPrimary),
                filled: true,
                fillColor: kCardBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories horizontal list
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: kPrimary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : kText),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                          _applyFilters();
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Status horizontal list
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _statuses.length,
              itemBuilder: (context, idx) {
                final status = _statuses[idx];
                final isSelected = _selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(status, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: kSecondary.withOpacity(0.3),
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = status;
                        _applyFilters();
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // Fleet List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kPrimary))
                : _filteredBikes.isEmpty
                    ? const Center(child: Text('No matching bicycles found in fleet.'))
                    : RefreshIndicator(
                        onRefresh: loadBikes,
                        color: kPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _filteredBikes.length,
                          itemBuilder: (context, index) {
                            final bike = _filteredBikes[index];
                            return _buildBikeCard(bike);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBikeCard(Map<String, dynamic> bike) {
    Color statusColor = Colors.green;
    if (bike['status'] == 'Rented') statusColor = kAccent;
    if (bike['status'] == 'Maintenance') statusColor = Colors.red.shade700;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BikeDetailsScreen(bikeId: bike['id']),
            ),
          );
          loadBikes();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike Image Thumbnail
            Container(
              width: 110,
              height: 110,
              color: kSecondaryBg,
              child: Image.network(
                bike['image_url'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.directions_bike,
                  size: 40,
                  color: kSecondary,
                ),
              ),
            ),
            // Bike Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kSecondaryBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            bike['category'],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimary),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            bike['status'],
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bike['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Frame Size: ${bike['frame_size']}',
                      style: TextStyle(color: kText.withOpacity(0.6), fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${bike['price_per_day']} / day',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kAccent),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditBikeModal({Map<String, dynamic>? bike}) {
    final isEdit = bike != null;
    final formKey = GlobalKey<FormState>();
    
    String name = isEdit ? bike['name'] : '';
    String category = isEdit ? bike['category'] : 'Mountain';
    String frameSize = isEdit ? bike['frame_size'] : 'M';
    double pricePerDay = isEdit ? bike['price_per_day'] : 20.0;
    String imageUrl = isEdit ? bike['image_url'] : 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=600&auto=format&fit=crop&q=60';
    String description = isEdit ? bike['description'] : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 50, height: 5, decoration: BoxDecoration(color: kSecondaryBg, borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 16),
                  Text(isEdit ? 'Edit Bicycle Details' : 'Register New Bicycle', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Bike Name', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter bike name' : null,
                    onSaved: (v) => name = v!.trim(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: category,
                          decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                          items: ['Mountain', 'Road', 'Hybrid', 'Electric', 'BMX']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => category = v!,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: frameSize,
                          decoration: const InputDecoration(labelText: 'Frame Size', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter size' : null,
                          onSaved: (v) => frameSize = v!.trim(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: pricePerDay.toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Rental Price (\$ per day)', border: OutlineInputBorder()),
                    validator: (v) => double.tryParse(v ?? '') == null ? 'Enter valid number' : null,
                    onSaved: (v) => pricePerDay = double.parse(v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: imageUrl,
                    decoration: const InputDecoration(labelText: 'Image Unsplash URL', border: OutlineInputBorder()),
                    onSaved: (v) => imageUrl = v?.trim() ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: description,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description / Tech Specs', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter description' : null,
                    onSaved: (v) => description = v!.trim(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final bikeMap = {
                            'name': name,
                            'category': category,
                            'frame_size': frameSize,
                            'price_per_day': pricePerDay,
                            'status': isEdit ? bike['status'] : 'Available',
                            'image_url': imageUrl,
                            'description': description,
                          };

                          if (isEdit) {
                            await DatabaseHelper.instance.updateBike(bike['id'], bikeMap);
                          } else {
                            await DatabaseHelper.instance.insertBike(bikeMap);
                          }
                          if (mounted) Navigator.pop(context);
                          loadBikes();
                        }
                      },
                      child: Text(isEdit ? 'Save Updates' : 'Add to Inventory'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- BIKE DETAILS SCREEN ---
class BikeDetailsScreen extends StatefulWidget {
  final int bikeId;
  const BikeDetailsScreen({super.key, required this.bikeId});

  @override
  State<BikeDetailsScreen> createState() => _BikeDetailsScreenState();
}

class _BikeDetailsScreenState extends State<BikeDetailsScreen> {
  Map<String, dynamic>? _bike;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBikeDetails();
  }

  Future<void> _loadBikeDetails() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllBikes();
    final found = list.firstWhere((element) => element['id'] == widget.bikeId);
    setState(() {
      _bike = found;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: kPrimary)));
    }
    if (_bike == null) {
      return const Scaffold(body: Center(child: Text('Bike not found.')));
    }

    final bike = _bike!;
    Color statusColor = Colors.green;
    if (bike['status'] == 'Rented') statusColor = kAccent;
    if (bike['status'] == 'Maintenance') statusColor = Colors.red.shade700;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(bike['name'], style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
              background: Image.network(bike['image_url'], fit: BoxFit.cover),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editBike(bike),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => _confirmDeleteBike(bike['id']),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text(bike['category'])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(bike['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecCell(Icons.straighten, 'Frame Size', bike['frame_size']),
                      _buildSpecCell(Icons.monetization_on, 'Daily Price', '\$${bike['price_per_day']}'),
                    ],
                  ),
                  const Divider(height: 32),
                  Text('Description & Technical Specifications', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(bike['description'], style: const TextStyle(height: 1.4, fontSize: 15)),
                  const Divider(height: 32),

                  // Operations Workflow buttons
                  if (bike['status'] == 'Available')
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Book New Rental Order', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _navigateToBooking(bike),
                      ),
                    ),

                  if (bike['status'] == 'Maintenance')
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kAccent, foregroundColor: Colors.white),
                        icon: const Icon(Icons.build_circle),
                        label: const Text('Complete Maintenance / Restore to Fleet', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _resolveBikeMaintenance(bike['id']),
                      ),
                    ),

                  if (bike['status'] == 'Rented')
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: kSecondaryBg, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: kText),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This bicycle is currently active on a customer rental contract. Go to the Rentals tab to manage its return or cancellation.',
                              style: TextStyle(fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSpecCell(IconData icon, String title, String val) {
    return Column(
      children: [
        Icon(icon, color: kSecondary, size: 28),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: kText.withOpacity(0.5), fontSize: 12)),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  void _navigateToBooking(Map<String, dynamic> bike) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRentalScreen(preSelectedBike: bike)),
    ).then((value) => _loadBikeDetails());
  }

  void _resolveBikeMaintenance(int id) {
    showDialog(
      context: context,
      builder: (context) {
        String resolutionNotes = '';
        return AlertDialog(
          title: const Text('Resolve Maintenance'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Enter calibration or repair actions notes...'),
            onChanged: (v) => resolutionNotes = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
              onPressed: () async {
                // Update maintenance rows and put bike back
                await DatabaseHelper.instance.updateBikeStatus(id, 'Available');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bicycle is marked Available for rental.')));
                }
                _loadBikeDetails();
              },
              child: const Text('Approve & Return'),
            )
          ],
        );
      },
    );
  }

  void _editBike(Map<String, dynamic> bike) {
    // Open standard sheet or sheet simulated
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit from inventory screen tab.')));
  }

  void _confirmDeleteBike(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bike permanently?'),
        content: const Text('This will remove the bicycle and all its associated records from the SQLite database.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteBike(id);
              if (mounted) {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // screen back
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bicycle removed.')));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 3. RENTAL BOOKING & FLOWS TAB
// ==========================================
class RentalsTab extends StatefulWidget {
  const RentalsTab({super.key});

  @override
  State<RentalsTab> createState() => _RentalsTabState();
}

class _RentalsTabState extends State<RentalsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _allRentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadRentals();
  }

  Future<void> loadRentals() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllRentals();
    setState(() {
      _allRentals = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeRentals = _allRentals.where((r) => r['status'] == 'Active').toList();
    final historicalRentals = _allRentals.where((r) => r['status'] != 'Active').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Agreements Booking'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: kSecondaryBg,
          indicatorColor: kAccent,
          tabs: const [
            Tab(text: 'Active Leases', icon: Icon(Icons.play_circle_fill_outlined)),
            Tab(text: 'History Log', icon: Icon(Icons.history_toggle_off)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRentalScreen()));
          loadRentals();
        },
        label: const Text('Book Order'),
        icon: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRentalsList(activeRentals, isActive: true),
                _buildRentalsList(historicalRentals, isActive: false),
              ],
            ),
    );
  }

  Widget _buildRentalsList(List<Map<String, dynamic>> list, {required bool isActive}) {
    if (list.isEmpty) {
      return Center(
        child: Text(isActive ? 'No active bike rentals currently.' : 'No rental history logs discovered.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final rental = list[idx];
        final start = DateTime.parse(rental['start_date']);
        final end = DateTime.parse(rental['end_date']);
        final days = end.difference(start).inDays <= 0 ? 1 : end.difference(start).inDays;

        Color statusColor = kPrimary;
        if (rental['status'] == 'Active') statusColor = kAccent;
        if (rental['status'] == 'Cancelled') statusColor = Colors.grey;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rental['customer_name'] ?? 'Client',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(rental['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text('Phone: ${rental['customer_phone']}', style: TextStyle(color: kText.withOpacity(0.6), fontSize: 13)),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Period Leased', style: TextStyle(fontSize: 11, color: kText.withOpacity(0.4))),
                        Text('${DateFormat('MMM dd, yyyy').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}'),
                        Text('Duration: $days days', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Bill', style: TextStyle(fontSize: 11, color: kText.withOpacity(0.4))),
                        Text('\$${rental['total_price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimary)),
                      ],
                    )
                  ],
                ),
                if (rental['notes'] != null && rental['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${rental['notes']}', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: kText.withOpacity(0.7))),
                ],
                if (isActive) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Cancel Lease'),
                        onPressed: () => _cancelRentalContract(rental['id']),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
                        icon: const Icon(Icons.assignment_return_outlined, size: 18),
                        label: const Text('Process Return'),
                        onPressed: () => _processBikeReturnDialog(rental['id']),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void _cancelRentalContract(int rentalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Rental Agreement?'),
        content: const Text('This will void the billing charge and automatically mark the underlying bicycles as Available immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep Lease')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () async {
              await DatabaseHelper.instance.cancelRental(rentalId);
              if (mounted) Navigator.pop(context);
              loadRentals();
            },
            child: const Text('Confirm Cancellation', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _processBikeReturnDialog(int rentalId) {
    final formKey = GlobalKey<FormState>();
    String damageNotes = '';
    double maintenanceCost = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Inspection Form'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Assess the bicycle condition before locking completion updates.', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Damage / Wear Notes (Optional)',
                  hintText: 'Leave empty if bike is completely intact',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => damageNotes = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated Repair Cost (If Damaged)',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => maintenanceCost = double.tryParse(v) ?? 0.0,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Dismiss')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
            onPressed: () async {
              await DatabaseHelper.instance.returnRental(rentalId, damageNotes: damageNotes, maintenanceCost: maintenanceCost);
              if (mounted) Navigator.pop(context);
              loadRentals();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rental returned successfully!')));
            },
            child: const Text('Finalize Return'),
          )
        ],
      ),
    );
  }
}

// --- DYNAMIC RENTAL CREATION SCREEN ---
class CreateRentalScreen extends StatefulWidget {
  final Map<String, dynamic>? preSelectedBike;
  const CreateRentalScreen({super.key, this.preSelectedBike});

  @override
  State<CreateRentalScreen> createState() => _CreateRentalScreenState();
}

class _CreateRentalScreenState extends State<CreateRentalScreen> {
  final _formKey = GlobalKey<FormState>();
  
  List<Map<String, dynamic>> _availableBikes = [];
  List<Map<String, dynamic>> _customers = [];
  
  int? _selectedBikeId;
  int? _selectedCustomerId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String _notes = '';

  double _bikePricePerDay = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    final bikes = await DatabaseHelper.instance.getAllBikes();
    final clients = await DatabaseHelper.instance.getAllCustomers();
    
    setState(() {
      _availableBikes = bikes.where((b) => b['status'] == 'Available').toList();
      _customers = clients;
      
      if (widget.preSelectedBike != null) {
        // Ensure preselected bike is inserted or appended if it's available
        _selectedBikeId = widget.preSelectedBike!['id'];
        _bikePricePerDay = (widget.preSelectedBike!['price_per_day'] as num).toDouble();
        if (!_availableBikes.any((b) => b['id'] == _selectedBikeId)) {
          _availableBikes.add(widget.preSelectedBike!);
        }
      }
      _isLoading = false;
    });
  }

  int get _rentalDuration {
    final diff = _endDate.difference(_startDate).inDays;
    return diff <= 0 ? 1 : diff;
  }

  double get _calculatedTotal {
    return _rentalDuration * _bikePricePerDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book New Bicycle Rental')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rental Parameters', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 16),

                      // Select Customer Dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedCustomerId,
                        decoration: const InputDecoration(labelText: 'Assign Customer Profile', border: OutlineInputBorder()),
                        items: _customers.map((c) {
                          return DropdownMenuItem<int>(
                            value: c['id'],
                            child: Text("${c['name']} (${c['phone']})"),
                          );
                        }).toList(),
                        validator: (v) => v == null ? 'Please assign a customer profile' : null,
                        onChanged: (v) => setState(() => _selectedCustomerId = v),
                      ),
                      const SizedBox(height: 16),

                      // Select Bike Dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedBikeId,
                        decoration: const InputDecoration(labelText: 'Choose Available Bicycle', border: OutlineInputBorder()),
                        items: _availableBikes.map((b) {
                          return DropdownMenuItem<int>(
                            value: b['id'],
                            child: Text("${b['name']} - \$${b['price_per_day']}/day [${b['category']}]"),
                          );
                        }).toList(),
                        validator: (v) => v == null ? 'Please choose a bike' : null,
                        onChanged: (v) {
                          setState(() {
                            _selectedBikeId = v;
                            final selectedBike = _availableBikes.firstWhere((element) => element['id'] == v);
                            _bikePricePerDay = (selectedBike['price_per_day'] as num).toDouble();
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Dates Pickers Row
                      Text('Duration & Range Settings', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Start Date', style: TextStyle(fontSize: 13, color: kSecondary)),
                              subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: const Icon(Icons.calendar_month, color: kPrimary),
                              tileColor: kCardBg,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (d != null) {
                                  setState(() {
                                    _startDate = d;
                                    if (_endDate.isBefore(_startDate)) {
                                      _endDate = _startDate.add(const Duration(days: 1));
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ListTile(
                              title: const Text('End Date', style: TextStyle(fontSize: 13, color: kSecondary)),
                              subtitle: Text(DateFormat('yyyy-MM-dd').format(_endDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: const Icon(Icons.calendar_month, color: kPrimary),
                              tileColor: kCardBg,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: _startDate,
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (d != null) {
                                  setState(() {
                                    _endDate = d;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dynamic Pricing Summary Widget
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kSecondaryBg.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kSecondary),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rate Per Day:'),
                                Text('\$${_bikePricePerDay.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Rental Duration:'),
                                Text('$_rentalDuration Days', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Dynamic Total Estimated:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('\$${_calculatedTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Rental Terms / Accessories Notes', border: OutlineInputBorder()),
                        onChanged: (v) => _notes = v,
                      ),
                      const SizedBox(height: 24),

                      // Confirm Action
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await DatabaseHelper.instance.bookRental(
                                customerId: _selectedCustomerId!,
                                bikeIds: [_selectedBikeId!],
                                startDate: _startDate,
                                endDate: _endDate,
                                totalPrice: _calculatedTotal,
                                notes: _notes,
                              );

                              if (success) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rental Lease Registered Successfully!')));
                                  Navigator.pop(context);
                                }
                              } else {
                                if (mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Lease Failure'),
                                      content: const Text('The chosen bike is no longer marked available. Prevented lease overlapping.'),
                                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text('Confirm & Initialize Lease contract', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 4. CUSTOMER PROFILE MANAGEMENT TAB
// ==========================================
class CustomersTab extends StatefulWidget {
  const CustomersTab({super.key});

  @override
  State<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllCustomers();
    setState(() {
      _customers = data;
      _applySearch();
      _isLoading = false;
    });
  }

  void _applySearch() {
    setState(() {
      _filteredCustomers = _customers.where((c) {
        return c['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['phone'].toString().contains(_searchQuery) ||
            c['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Database Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCustomerFormModal(),
        tooltip: 'Add Customer',
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) {
                _searchQuery = val;
                _applySearch();
              },
              decoration: InputDecoration(
                hintText: 'Search customer name, email or phone...',
                prefixIcon: const Icon(Icons.search, color: kPrimary),
                filled: true,
                fillColor: kCardBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kPrimary))
                : _filteredCustomers.isEmpty
                    ? const Center(child: Text('No customers registered.'))
                    : RefreshIndicator(
                        onRefresh: loadCustomers,
                        color: kPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredCustomers.length,
                          itemBuilder: (context, idx) {
                            final client = _filteredCustomers[idx];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: kSecondaryBg,
                                  child: Icon(Icons.person, color: kPrimary),
                                ),
                                title: Text(client['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text("📞 ${client['phone']}"),
                                    Text("✉️ ${client['email']}"),
                                    Text("🆔 Doc: ${client['id_number']}"),
                                    Text("📍 ${client['address']}", style: TextStyle(color: kText.withOpacity(0.5), fontSize: 12)),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: kSecondary),
                                      onPressed: () => _openCustomerFormModal(customer: client),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => _confirmDeleteCustomer(client['id']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _openCustomerFormModal({Map<String, dynamic>? customer}) {
    final isEdit = customer != null;
    final formKey = GlobalKey<FormState>();

    String name = isEdit ? customer['name'] : '';
    String email = isEdit ? customer['email'] : '';
    String phone = isEdit ? customer['phone'] : '';
    String idNumber = isEdit ? customer['id_number'] : '';
    String address = isEdit ? customer['address'] : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(isEdit ? 'Update Customer Profile' : 'Register Customer Profile', style: Theme.of(context).textTheme.headlineMedium),
                  const Divider(),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                    onSaved: (v) => name = v!.trim(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                    validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                    onSaved: (v) => email = v!.trim(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter phone number' : null,
                    onSaved: (v) => phone = v!.trim(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: idNumber,
                    decoration: const InputDecoration(labelText: 'ID / Passport Number', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter identification doc reference' : null,
                    onSaved: (v) => idNumber = v!.trim(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: address,
                    decoration: const InputDecoration(labelText: 'Home/Billing Address', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter physical address' : null,
                    onSaved: (v) => address = v!.trim(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final clientMap = {
                            'name': name,
                            'email': email,
                            'phone': phone,
                            'id_number': idNumber,
                            'address': address
                          };

                          if (isEdit) {
                            await DatabaseHelper.instance.updateCustomer(customer['id'], clientMap);
                          } else {
                            await DatabaseHelper.instance.insertCustomer(clientMap);
                          }
                          if (mounted) Navigator.pop(context);
                          loadCustomers();
                        }
                      },
                      child: Text(isEdit ? 'Save Profile changes' : 'Create Profile Contract'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteCustomer(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer Profile?'),
        content: const Text('All active or historical records related to this customer will be removed or cascade constraints handled inside SQLite.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteCustomer(id);
              if (mounted) Navigator.pop(context);
              loadCustomers();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 5. STATISTICS & ANALYTICS BAR CHART VIEW
// ==========================================
class SettingsStatsTab extends StatefulWidget {
  const SettingsStatsTab({super.key});

  @override
  State<SettingsStatsTab> createState() => _SettingsStatsTabState();
}

class _SettingsStatsTabState extends State<SettingsStatsTab> {
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _maintenanceLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => _isLoading = true);
    final s = await DatabaseHelper.instance.getStatistics();
    final logs = await DatabaseHelper.instance.getMaintenanceRecords();
    setState(() {
      _stats = s;
      _maintenanceLogs = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: kPrimary)));
    }

    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final List<dynamic> breakdown = _stats['categoryBreakdown'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Fleet Metrics & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Financial & Distribution Analytics', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Card(
              color: kSecondaryBg,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Net Earnings:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(currencyFormat.format(_stats['totalEarnings']), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fleet Availability Proportion UI Bar Chart
            Text('Fleet Availability Ratio', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildRatioSegment('Available', _stats['availableBikes'], Colors.green),
                        _buildRatioSegment('Rented', _stats['rentedBikes'], kAccent),
                        _buildRatioSegment('Maintenance', _stats['maintenanceBikes'], Colors.red.shade700),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    _buildLegendItem('Available Inventory', '${_stats['availableBikes']}', Colors.green),
                    _buildLegendItem('Active Rentals', '${_stats['rentedBikes']}', kAccent),
                    _buildLegendItem('Under Maintenance / Damaged', '${_stats['maintenanceBikes']}', Colors.red.shade700),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories Breakdown custom visualization
            Text('Bicycle Fleet Categories Breakdown', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: breakdown.isEmpty
                    ? const Center(child: Text('No categorized fleet.'))
                    : Column(
                        children: breakdown.map<Widget>((item) {
                          final count = item['count'] as int;
                          final categoryName = item['category'] as String;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                SizedBox(width: 80, child: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: count / 10.0, // Scale out of 10 max
                                      color: kPrimary,
                                      backgroundColor: kSecondaryBg,
                                      minHeight: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text('$count units', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Maintenance Records Notes Log
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Damage & Maintenance Logs', style: Theme.of(context).textTheme.titleLarge),
                IconButton(icon: const Icon(Icons.refresh), onPressed: loadStats)
              ],
            ),
            const SizedBox(height: 6),
            _maintenanceLogs.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('No ongoing maintenance records found.')),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _maintenanceLogs.length,
                    itemBuilder: (context, idx) {
                      final log = _maintenanceLogs[idx];
                      final date = DateTime.parse(log['maintenance_date']);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.build_rounded, color: kAccent),
                          title: Text(log['bike_name'] ?? 'Bicycle Component'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['description']),
                              const SizedBox(height: 2),
                              Text("Cost Logged: \$${log['cost']} • ${DateFormat('yyyy-MM-dd').format(date)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              if (log['notes'] != null) Text("Status: ${log['notes']}", style: TextStyle(color: kPrimary.withOpacity(0.8), fontSize: 12, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioSegment(String title, int count, Color col) {
    if (count == 0) return const SizedBox.shrink();
    return Expanded(
      flex: count,
      child: Container(
        height: 18,
        color: col,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color col) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
