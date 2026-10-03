import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';
import 'service_details_screen.dart';
import '../services/database_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All';
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _services = [];
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load categories with timeout/error handling
      try {
        final cats = await _dbService.getCategories();
        if (mounted && cats.isNotEmpty) {
          setState(() {
            _categories = ['All', ...cats.map((c) => c['name'].toString())];
          });
        }
      } catch (e) {
        debugPrint('Categories fetch failed, using defaults: $e');
        // Fallback categories already in _categories
      }

      // Load services
      try {
        final fetchedServices = await _dbService.getServices(
          categoryName: _selectedCategory == 'All' ? null : _selectedCategory
        );
        
        if (mounted) {
          setState(() {
            _services = fetchedServices;
            _isLoading = false;
          });
          if (fetchedServices.isEmpty) {
            _useDemoData();
          }
        }
      } catch (e) {
        debugPrint('Services fetch failed, using demo data: $e');
        _useDemoData();
      }
    } catch (e) {
      _useDemoData();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _useDemoData() {
    setState(() {
      _services = [
        {
          'name': 'Signature Haircut',
          'price': '45.00',
          'duration_minutes': 45,
          'description': 'Premium haircut and styling.',
          'image_url': 'https://images.unsplash.com/photo-1560869713-7d0a29430803?auto=format&fit=crop&q=80&w=2574'
        },
        {
          'name': 'Glow Facial',
          'price': '65.00',
          'duration_minutes': 60,
          'description': 'Deep skin cleansing.',
          'image_url': 'https://images.unsplash.com/photo-1512290923902-8a9f81dc206e?auto=format&fit=crop&q=80&w=2670'
        }
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightPink,
      appBar: AppBar(
        title: const Text('Our Services'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildCategoryFilter(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text('Database Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _loadData, child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (_services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No services found in $_selectedCategory', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Add services in Supabase to see them here!', style: TextStyle(fontSize: 12, color: Colors.blue)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = category);
              _loadData();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryRosePink : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.softRose),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: service)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                service['image_url'] ?? 'https://images.unsplash.com/photo-1560869713-7d0a29430803?auto=format&fit=crop&q=80&w=2574',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(service['name'] ?? 'Service', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepRose), overflow: TextOverflow.ellipsis)),
                      Text('\$${service['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryRosePink)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(service['description'] ?? 'No description', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${service['duration_minutes'] ?? 0} mins', style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Text('Book Now', style: TextStyle(color: AppTheme.primaryRosePink, fontWeight: FontWeight.bold)),
                      const Icon(Icons.arrow_forward, size: 16, color: AppTheme.primaryRosePink),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
