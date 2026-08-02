import 'package:flutter/material.dart';

void main() => runApp(const WanderlustTravelApp());

class WanderlustTravelApp extends StatelessWidget {
  const WanderlustTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanderlust Travel Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const TravelHomeScreen(),
    );
  }
}

class TravelHomeScreen extends StatefulWidget {
  const TravelHomeScreen({super.key});

  @override
  State<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Mountains', 'Lakes', 'Cities', 'Forests'];
  String _searchQuery = '';

  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Snow Skiing',
      'price': '\$120',
      'rating': '4.8',
      'category': 'Mountains',
      'image': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?auto=format&fit=crop&w=400&q=80'
    },
    {
      'title': 'Mountain Hike',
      'price': '\$85',
      'rating': '4.9',
      'category': 'Mountains',
      'image': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=400&q=80'
    },
    {
      'title': 'Alpine Boat Tour',
      'price': '\$95',
      'rating': '4.7',
      'category': 'Lakes',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredActivities = _activities.where((activity) {
      final matchesSearch = activity['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryIndex == 0 || activity['category'] == _categories[_selectedCategoryIndex];
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Explore Destination', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('Switzerland Alps 🏔️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.notifications_none, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search places, activities...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categories Filter
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
                        selectedColor: const Color(0xFF0EA5E9),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (selected) => setState(() => _selectedCategoryIndex = index),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Main Banner Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DestinationDetailScreen(
                        title: 'Interlaken Valley',
                        location: 'Central Switzerland',
                        rating: '4.9',
                        reviews: '1,420',
                        imageUrl: 'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?auto=format&fit=crop&w=800&q=80',
                        description: 'Interlaken is a traditional resort town in the mountainous Bernese Oberland region of central Switzerland. Built between emerald-colored lakes, surrounded by dense forests and glaciers.',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'interlaken_banner',
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?auto=format&fit=crop&w=800&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Interlaken Valley', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('⭐ 4.9 (1,420 Reviews) • Central Switzerland', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Popular Activities Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('${filteredActivities.length} available', style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 14),

              filteredActivities.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Text('No activities found.', style: TextStyle(color: Colors.grey))),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredActivities.length,
                itemBuilder: (context, index) {
                  final act = filteredActivities[index];
                  return _ActivityCard(title: act['title'], price: act['price'], rating: act['rating'], image: act['image']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatefulWidget {
  final String title, price, rating, image;
  const _ActivityCard({required this.title, required this.price, required this.rating, required this.image});

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(widget.image, height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => isFavorite = !isFavorite),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey, size: 16),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.price, style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold, fontSize: 13)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 13),
                        const SizedBox(width: 2),
                        Text(widget.rating, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationDetailScreen extends StatelessWidget {
  final String title, location, rating, reviews, imageUrl, description;
  const DestinationDetailScreen({
    super.key, required this.title, required this.location, required this.rating, required this.reviews, required this.imageUrl, required this.description,
  });

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Confirm Your Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            const TextField(decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Select Date (e.g., Aug 15)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip booked successfully! 🎉')));
                },
                child: const Text('Proceed & Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'interlaken_banner',
                  child: Image.network(imageUrl, height: 360, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                                    const SizedBox(width: 4),
                                    Text(location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('$rating ($reviews)', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _HighlightItem(icon: Icons.hotel, label: 'Hotel'),
                          _HighlightItem(icon: Icons.flight, label: 'Flight'),
                          _HighlightItem(icon: Icons.local_activity, label: 'Guide'),
                          _HighlightItem(icon: Icons.restaurant, label: 'Meals'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('About Destination', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -4))]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('\$250 / person', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _showBookingSheet(context),
                    child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HighlightItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: const Color(0xFF0EA5E9), size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
      ],
    );
  }
}