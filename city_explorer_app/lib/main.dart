import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// --- MODELS ---

class City {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final List<Place> places;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.places,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    var placesList = json['places'] as List;
    return City(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      places: placesList.map((p) => Place.fromJson(p)).toList(),
    );
  }
}

class Place {
  final String id;
  final String name;
  final String category;
  final String description;
  final double rating;
  final String imageUrl;
  final List<String> gallery;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.gallery,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      gallery: List<String>.from(json['gallery'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'rating': rating,
    'imageUrl': imageUrl,
    'gallery': gallery,
  };
}

class Trip {
  final String id;
  String name;
  List<Place> places;
  List<Note> notes;
  DateTime date;

  Trip({
    required this.id,
    required this.name,
    required this.places,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'places': places.map((p) => p.toJson()).toList(),
    'notes': notes.map((n) => n.toJson()).toList(),
    'date': date.toIso8601String(),
  };

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      places: (json['places'] as List).map((p) => Place.fromJson(p)).toList(),
      notes: (json['notes'] as List).map((n) => Note.fromJson(n)).toList(),
      date: DateTime.parse(json['date']),
    );
  }
}

class Note {
  final String id;
  String content;
  DateTime timestamp;

  Note({required this.id, required this.content, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// --- PROVIDER ---

class AppProvider with ChangeNotifier {
  List<City> _cities = [];
  List<String> _favoritePlaceIds = [];
  List<Trip> _trips = [];
  bool _isLoading = true;

  List<City> get cities => _cities;
  List<String> get favoritePlaceIds => _favoritePlaceIds;
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadCities();
    await loadUserData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCities() async {
    try {
      final String response = await rootBundle.loadString('assets/data/cities.json');
      final data = await json.decode(response) as List;
      _cities = data.map((c) => City.fromJson(c)).toList();
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load favorites
    _favoritePlaceIds = prefs.getStringList('favorites') ?? [];
    
    // Load trips
    final tripsJson = prefs.getString('trips');
    if (tripsJson != null) {
      final List decoded = json.decode(tripsJson);
      _trips = decoded.map((t) => Trip.fromJson(t)).toList();
    }
  }

  Future<void> toggleFavorite(String placeId) async {
    if (_favoritePlaceIds.contains(placeId)) {
      _favoritePlaceIds.remove(placeId);
    } else {
      _favoritePlaceIds.add(placeId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoritePlaceIds);
  }

  bool isFavorite(String placeId) => _favoritePlaceIds.contains(placeId);

  Future<void> addTrip(String name) async {
    final newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      places: [],
      notes: [],
      date: DateTime.now(),
    );
    _trips.add(newTrip);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> removeTrip(String tripId) async {
    _trips.removeWhere((t) => t.id == tripId);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> addPlaceToTrip(String tripId, Place place) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      if (!_trips[index].places.any((p) => p.id == place.id)) {
        _trips[index].places.add(place);
        notifyListeners();
        await _saveTrips();
      }
    }
  }

  Future<void> removePlaceFromTrip(String tripId, String placeId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      _trips[index].places.removeWhere((p) => p.id == placeId);
      notifyListeners();
      await _saveTrips();
    }
  }

  Future<void> addNoteToTrip(String tripId, String content) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      _trips[index].notes.add(Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
      await _saveTrips();
    }
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trips', json.encode(_trips.map((t) => t.toJson()).toList()));
  }

  List<Place> getFavoritePlaces() {
    List<Place> allPlaces = [];
    for (var city in _cities) {
      allPlaces.addAll(city.places);
    }
    return allPlaces.where((p) => _favoritePlaceIds.contains(p.id)).toList();
  }
}

// --- MAIN ---

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const CityExplorerApp(),
    ),
  );
}

class CityExplorerApp extends StatelessWidget {
  const CityExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF146C94), // Primary: #146C94
          primary: const Color(0xFF146C94),
          secondary: const Color(0xFF19A7CE),
          surface: const Color(0xFFEAF6FF), // Background: #EAF6FF
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF6FF),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(color: const Color(0xFF17324D), fontWeight: FontWeight.bold),
          bodyLarge: GoogleFonts.poppins(color: const Color(0xFF17324D)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF146C94),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFF7FCFF),
          elevation: 2,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- SCREENS ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF146C94),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.explore, size: 100, color: Color(0xFFF4A261)),
            const SizedBox(height: 20),
            Text(
              'CITY EXPLORER',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Discover your next adventure',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Color(0xFFF4A261)),
          ],
        ),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const TripListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF146C94),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredCities = provider.cities
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                      c.country.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search bar or focus
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search cities...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFCDE8F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                final city = filteredCities[index];
                return CityCard(city: city);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final City city;
  const CityCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CityDashboardScreen(city: city)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(city.imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city.name,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                city.country,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityDashboardScreen extends StatelessWidget {
  final City city;
  const CityDashboardScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final categories = ["Popular", "Restaurants", "Parks", "Museums", "Shopping", "Attractions"];

    return Scaffold(
      appBar: AppBar(title: Text(city.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City Header
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(city.imageUrl), fit: BoxFit.cover),
              ),
              child: Container(
                color: Colors.black26,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Text(
                  city.description,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    title: categories[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPlacesScreen(city: city, category: categories[index]),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Must Visit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: city.places.take(3).length,
              itemBuilder: (context, index) {
                final place = city.places[index];
                return PlaceListItem(place: place);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CategoryTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (title) {
      case "Restaurants": icon = Icons.restaurant; break;
      case "Parks": icon = Icons.park; break;
      case "Museums": icon = Icons.museum; break;
      case "Shopping": icon = Icons.shopping_bag; break;
      case "Attractions": icon = Icons.camera_alt; break;
      default: icon = Icons.star;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF19A7CE),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class CategoryPlacesScreen extends StatelessWidget {
  final City city;
  final String category;
  const CategoryPlacesScreen({super.key, required this.city, required this.category});

  @override
  Widget build(BuildContext context) {
    final places = category == "Popular" 
      ? city.places 
      : city.places.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: places.isEmpty 
        ? const Center(child: Text("No places found in this category."))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: places.length,
            itemBuilder: (context, index) => PlaceListItem(place: places[index]),
          ),
    );
  }
}

class PlaceListItem extends StatelessWidget {
  final Place place;
  const PlaceListItem({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: Image.network(place.imageUrl, width: 120, height: 100, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF4A261), size: 16),
                        const SizedBox(width: 4),
                        Text(place.rating.toString(), style: const TextStyle(fontSize: 14)),
                        const Spacer(),
                        Text(place.category, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
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
}

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(place.imageUrl, fit: BoxFit.cover),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isFavorite(place.id) ? Icons.favorite : Icons.favorite_border,
                  color: provider.isFavorite(place.id) ? Colors.red : Colors.white,
                ),
                onPressed: () => provider.toggleFavorite(place.id),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(place.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: const Color(0xFFF4A261), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 20),
                            const SizedBox(width: 5),
                            Text(place.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(place.category, style: TextStyle(color: const Color(0xFF19A7CE), fontWeight: FontWeight.w600, fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(place.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 25),
                  
                  if (place.gallery.isNotEmpty) ...[
                    const Text('Gallery', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: place.gallery.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: NetworkImage(place.gallery[index]), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],

                  ElevatedButton.icon(
                    onPressed: () => _showAddToTripDialog(context, place),
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Trip Itinerary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF146C94),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showAddToTripDialog(BuildContext context, Place place) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFEAF6FF),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add to Trip', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (provider.trips.isEmpty)
                const Center(child: Text("No trips created yet. Go to Trips tab to create one."))
              else
                ...provider.trips.map((trip) => ListTile(
                  leading: const Icon(Icons.map, color: Color(0xFF146C94)),
                  title: Text(trip.name),
                  onTap: () {
                    provider.addPlaceToTrip(trip.id, place);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to ${trip.name}')),
                    );
                  },
                )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<AppProvider>(context).getFavoritePlaces();

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite places yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) => PlaceListItem(place: favorites[index]),
            ),
    );
  }
}

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: provider.trips.isEmpty
          ? const Center(child: Text('No trips planned yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.trips.length,
              itemBuilder: (context, index) {
                final trip = provider.trips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(trip.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text('${trip.places.length} places • ${DateFormat('MMM d, yyyy').format(trip.date)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.removeTrip(trip.id),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TripDetailScreen(trip: trip)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTripDialog(context),
        backgroundColor: const Color(0xFFF4A261),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateTripDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Trip'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Trip name (e.g., Summer in SF)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false).addTrip(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.trip.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Itinerary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (widget.trip.places.isEmpty)
              const Text('No places added to this trip yet.')
            else
              ...widget.trip.places.map((place) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(place.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(place.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => provider.removePlaceFromTrip(widget.trip.id, place.id),
                      ),
                    ),
                  )),
            
            const SizedBox(height: 30),
            const Text('Notes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...widget.trip.notes.map((note) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.content, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(DateFormat('MMM d, h:mm a').format(note.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )),
            
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Add a note...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF146C94)),
                  onPressed: () {
                    if (_noteController.text.isNotEmpty) {
                      provider.addNoteToTrip(widget.trip.id, _noteController.text);
                      _noteController.clear();
                    }
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  provider.addNoteToTrip(widget.trip.id, val);
                  _noteController.clear();
                }
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About City Explorer'),
            onTap: () {},
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Logout'),
            ),
          )
        ],
      ),
    );
  }
}
