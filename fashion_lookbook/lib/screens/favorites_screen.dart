import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lookbook_model.dart';
import '../theme/app_theme.dart';
import '../services/favorites_service.dart';
import '../widgets/look_card.dart';
import 'look_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesService _favoritesService = FavoritesService();
  LookbookData? _data;
  List<Look> _favLooks = [];
  List<ClothingItem> _favItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    final String response = await rootBundle.loadString('assets/data/lookbook.json');
    final jsonData = await json.decode(response);
    _data = LookbookData.fromJson(jsonData);

    final favLookIds = await _favoritesService.getFavoriteLooks();
    final favItemIds = await _favoritesService.getFavoriteItems();

    setState(() {
      _favLooks = _data!.featuredLooks.where((l) => favLookIds.contains(l.id)).toList();
      _favItems = _data!.items.where((i) => favItemIds.contains(i.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITES'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.secondary.withAlpha(128),
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Looks'),
            Tab(text: 'Items'),
          ],
        ),
      ),
      body: _data == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLooksList(),
                _buildItemsList(),
              ],
            ),
    );
  }

  Widget _buildLooksList() {
    if (_favLooks.isEmpty) {
      return const Center(child: Text('No favorite looks yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favLooks.length,
      itemBuilder: (context, index) {
        final look = _favLooks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: LookCard(
            look: look,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LookDetailsScreen(
                    look: look,
                    allItems: _data!.items,
                  ),
                ),
              );
              _loadAll(); // Refresh favorites after returning
            },
          ),
        );
      },
    );
  }

  Widget _buildItemsList() {
    if (_favItems.isEmpty) {
      return const Center(child: Text('No favorite items yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favItems.length,
      itemBuilder: (context, index) {
        final item = _favItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.image, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.brand),
            trailing: Text('\$${item.price}', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
