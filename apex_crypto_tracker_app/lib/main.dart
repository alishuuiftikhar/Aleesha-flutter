import 'package:flutter/material.dart';

void main() => runApp(const CryptoTrackerApp());

class CryptoTrackerApp extends StatelessWidget {
  const CryptoTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1), brightness: Brightness.dark), // Updated primary color to indigo
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slightly deeper background
        fontFamily: 'Inter', // Changed to Inter font for a modern look (ensure you have this font, fallback is Roboto)
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F172A), elevation: 0),
      ),
      home: const CryptoHomeScreen(),
    );
  }
}

class CryptoHomeScreen extends StatefulWidget {
  const CryptoHomeScreen({super.key});

  @override
  State<CryptoHomeScreen> createState() => _CryptoHomeScreenState();
}

class _CryptoHomeScreenState extends State<CryptoHomeScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> coins = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'price': '\$69,420.50', 'change': '+4.2%', 'isUp': true, 'icon': Icons.currency_bitcoin, 'chartColor': Colors.greenAccent},
    {'name': 'Ethereum', 'symbol': 'ETH', 'price': '\$3,710.20', 'change': '+2.8%', 'isUp': true, 'icon': Icons.bolt, 'chartColor': Colors.greenAccent},
    {'name': 'Solana', 'symbol': 'SOL', 'price': '\$162.80', 'change': '-3.5%', 'isUp': false, 'icon': Icons.blur_on, 'chartColor': Colors.redAccent},
    {'name': 'Cardano', 'symbol': 'ADA', 'price': '\$0.58', 'change': '+1.9%', 'isUp': true, 'icon': Icons.token, 'chartColor': Colors.greenAccent},
    {'name': 'Ripple', 'symbol': 'XRP', 'price': '\$0.51', 'change': '-1.4%', 'isUp': false, 'icon': Icons.currency_exchange, 'chartColor': Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredCoins = coins;
    if (_selectedTab == 1) {
      filteredCoins = coins.where((c) => c['isUp'] == true).toList();
    } else if (_selectedTab == 2) {
      filteredCoins = coins.where((c) => c['isUp'] == false).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'), // Professional profile pic example
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning 👋', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400)),
                Text('Alex Thompson', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: const Badge(
              backgroundColor: Color(0xFF6366F1),
              label: Text('2', style: TextStyle(fontSize: 10, color: Colors.white)),
              child: Icon(Icons.notifications_none_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional Portfolio Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF818CF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL BALANCE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.show_chart, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('USD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('\$42,850.90', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1.0)),
                  const SizedBox(height: 4),
                  const Text('+ \$2,180.75 (5.4%) Today', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),

                  // Stylish Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.north_east, 'Send'),
                      _buildActionButton(Icons.south_west, 'Receive'),
                      _buildActionButton(Icons.swap_horiz, 'Swap'),
                      _buildActionButton(Icons.history, 'History'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Elegant Market Tabs
            Row(
              children: [
                _buildTabButton('Overview', 0),
                _buildTabButton('Top Gainers', 1),
                _buildTabButton('Top Losers', 2),
              ],
            ),
            const SizedBox(height: 24),

            // Market Section Title
            const Text('Popular Coins', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),

            // Professional Minimalist Coin List
            ...filteredCoins.map((coin) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Slightly lighter than scaffold for subtle separation
                borderRadius: BorderRadius.circular(20),
                // No borders, just the card style
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF334155),
                    child: Icon(coin['icon'], color: const Color(0xFF818CF8), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coin['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(coin['symbol'], style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  // Mini Chart Representation (Simple Text for now, can be replaced with flutter_chart packages)
                  const SizedBox(width: 10),
                  const Icon(Icons.show_chart, color: Colors.grey, size: 30,),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(coin['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        coin['change'],
                        style: TextStyle(
                          color: coin['isUp'] ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: const Color(0xFF818CF8),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Exchange'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}