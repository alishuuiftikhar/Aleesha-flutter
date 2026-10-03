import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllFavorites();
    if (mounted) {
      setState(() {
        _favorites = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(String type, int itemId) async {
    await DatabaseHelper.instance.removeFavorite(type, itemId);
    _loadFavorites();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites'), backgroundColor: AppTheme.primary),
      );
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Visitor':
        return Icons.person_pin_rounded;
      case 'Delivery':
        return Icons.local_shipping_rounded;
      case 'Maintenance':
        return Icons.build_circle_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred & Favorites'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _favorites.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.star_border_rounded,
                  title: 'No Favorites Yet',
                  description: 'Star important visitors, expected deliveries, or frequent maintenance providers for quick access.',
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final fav = _favorites[index];
                      final type = fav['item_type'] as String? ?? 'Item';
                      final title = fav['title'] as String? ?? '';
                      final subtitle = fav['subtitle'] as String? ?? '';
                      final itemId = fav['item_id'] as int? ?? 0;

                      return CustomCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_getTypeIcon(type), color: AppTheme.accent, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          type,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (subtitle.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      subtitle,
                                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.star_rounded, color: AppTheme.accent, size: 26),
                              onPressed: () => _removeFavorite(type, itemId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
