import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/astronomy_object.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';

class ObjectDetailsScreen extends StatelessWidget {
  final AstronomyObject object;

  const ObjectDetailsScreen({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(object.name),
              background: Hero(
                tag: 'img_${object.id}',
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(context, object.image),
                  child: Image.network(
                    object.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<AstronomyProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.favorites.any((o) => o.id == object.id);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: AppColors.error),
                    onPressed: () => provider.toggleFavorite(object),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipRow(object),
                  const SizedBox(height: 20),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(object.description, style: const TextStyle(height: 1.6, fontSize: 16)),
                  const SizedBox(height: 24),
                  if (object.distance != null || object.size != null) ...[
                    Text('Physical Properties', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    _buildPropertyTile(Icons.straighten, 'Size', object.size ?? 'N/A'),
                    _buildPropertyTile(Icons.space_dashboard, 'Distance', object.distance ?? 'N/A'),
                    const SizedBox(height: 24),
                  ],
                  if (object.discoveryInfo != null && object.discoveryInfo!.isNotEmpty) ...[
                    Text('Discovery', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(object.discoveryInfo!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                  ],
                  if (object.facts.isNotEmpty) ...[
                    Text('Interesting Facts', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    ...object.facts.map((fact) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.star, color: AppColors.accent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(fact)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),
                  ],
                  if (object.relatedObjects.isNotEmpty) ...[
                    Text('Related Objects', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: object.relatedObjects.map((name) => ActionChip(
                        label: Text(name),
                        backgroundColor: AppColors.secondaryBackground,
                        onPressed: () {
                          final provider = Provider.of<AstronomyProvider>(context, listen: false);
                          final related = provider.objects.firstWhere((o) => o.name == name, orElse: () => object);
                          if (related.name != object.name) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ObjectDetailsScreen(object: related)));
                          }
                        },
                      )).toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipRow(AstronomyObject object) {
    return Row(
      children: [
        Chip(
          label: Text(object.category),
          backgroundColor: AppColors.primary.withOpacity(0.2),
          labelStyle: const TextStyle(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildPropertyTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    ));
  }
}
