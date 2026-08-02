import 'package:flutter/material.dart';

void main() => runApp(const LuminaSmartHomeApp());

class LuminaSmartHomeApp extends StatelessWidget {
  const LuminaSmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina Smart Home Elite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF040711),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationShell(),
    );
  }
}

// 1. Navigation Shell with Glowing Active Indicators
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SmartHomeDashboard(),
    const _PlaceholderScreen(title: 'Energy Analytics', icon: Icons.bar_chart_rounded),
    const _PlaceholderScreen(title: 'Automations Hub', icon: Icons.bolt_rounded),
    const _PlaceholderScreen(title: 'User Profile & Settings', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1D),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.blueAccent.withOpacity(0.25),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.home_rounded, color: Colors.blueAccent),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.bar_chart_rounded, color: Colors.blueAccent),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.bolt_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.bolt_rounded, color: Colors.blueAccent),
              label: 'Scenes',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.grey),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.blueAccent),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class SmartHomeDashboard extends StatefulWidget {
  const SmartHomeDashboard({super.key});

  @override
  State<SmartHomeDashboard> createState() => _SmartHomeDashboardState();
}

class _SmartHomeDashboardState extends State<SmartHomeDashboard> {
  bool _isLivingRoomLightOn = true;
  bool _isAcOn = false;
  bool _isSecurityArmed = true;
  bool _isTvOn = false;
  bool _isPurifierOn = true;
  double _temperatureVal = 22.0;
  double _lightBrightness = 85.0;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = ['All Rooms', 'Living Room', 'Bed Room', 'Kitchen', 'Outdoor'];

  // Interactive Brightness Modal
  void _showBrightnessModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0E1626),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 28),
                          SizedBox(width: 12),
                          Text('Main Lights Control', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Brightness Level', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('${_lightBrightness.toInt()}%', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.amber,
                      inactiveTrackColor: Colors.white12,
                      thumbColor: Colors.amber,
                      overlayColor: Colors.amber.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _lightBrightness,
                      min: 0,
                      max: 100,
                      onChanged: (val) {
                        setModalState(() => _lightBrightness = val);
                        setState(() => _isLivingRoomLightOn = val > 0);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.indigo]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.home_filled, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LUMINA ELITE', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 2.0)),
                        SizedBox(height: 2),
                        Text('Alex\'s Residence', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 22),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Quick Interactive Scenes
            const Text('Smart Scenes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSceneCard(Icons.nightlight_round, 'Sleep', Colors.indigoAccent),
                _buildSceneCard(Icons.movie_rounded, 'Movie', Colors.deepPurpleAccent),
                _buildSceneCard(Icons.wb_sunny_rounded, 'Morning', Colors.amber),
                _buildSceneCard(Icons.security_rounded, 'Away', Colors.redAccent),
              ],
            ),
            const SizedBox(height: 24),

            // Categories Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: isSelected,
                      selectedColor: Colors.blueAccent,
                      backgroundColor: const Color(0xFF111827),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? Colors.blueAccent : Colors.white10),
                      ),
                      onSelected: (bool selected) => setState(() => _selectedCategoryIndex = index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Master Climate Control Hub
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(color: Colors.blueAccent.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.ac_unit_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Climate Control Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Switch.adaptive(
                        value: _isAcOn,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.blue.shade900,
                        onChanged: (val) => setState(() => _isAcOn = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Target Temperature', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${_temperatureVal.toStringAsFixed(1)}°C', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Outdoor Status', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            SizedBox(height: 2),
                            Text('28°C • Humid', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _temperatureVal,
                    min: 16.0,
                    max: 30.0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: _isAcOn ? (val) => setState(() => _temperatureVal = val) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Devices Section Title
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Connected Devices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Manage', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),

            // Grid Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                _DeviceCard(
                  title: 'Main Lights',
                  subtitle: _isLivingRoomLightOn ? '${_lightBrightness.toInt()}% Active' : 'Offline',
                  icon: Icons.lightbulb_rounded,
                  isOn: _isLivingRoomLightOn,
                  onTap: () => setState(() => _isLivingRoomLightOn = !_isLivingRoomLightOn),
                  onLongPress: _showBrightnessModal,
                ),
                _DeviceCard(
                  title: 'Security Alarm',
                  subtitle: _isSecurityArmed ? 'Armed & Secure' : 'Disarmed',
                  icon: Icons.security_rounded,
                  isOn: _isSecurityArmed,
                  onTap: () => setState(() => _isSecurityArmed = !_isSecurityArmed),
                  onLongPress: () {},
                ),
                _DeviceCard(
                  title: 'Smart TV',
                  subtitle: _isTvOn ? 'Streaming 4K' : 'Standby',
                  icon: Icons.tv_rounded,
                  isOn: _isTvOn,
                  onTap: () => setState(() => _isTvOn = !_isTvOn),
                  onLongPress: () {},
                ),
                _DeviceCard(
                  title: 'Air Purifier',
                  subtitle: _isPurifierOn ? 'Auto Mode' : 'Off',
                  icon: Icons.air_rounded,
                  isOn: _isPurifierOn,
                  onTap: () => setState(() => _isPurifierOn = !_isPurifierOn),
                  onLongPress: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneCard(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF10172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isOn;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _DeviceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isOn,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFF131D31) : const Color(0xFF0C111D),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isOn ? Colors.blueAccent.withOpacity(0.5) : Colors.white.withOpacity(0.06),
            width: isOn ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isOn ? Colors.blueAccent.withOpacity(0.2) : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: isOn ? Colors.blueAccent : Colors.grey, size: 24),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOn ? Colors.blueAccent : Colors.grey.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(color: isOn ? Colors.white70 : Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.blueAccent),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}