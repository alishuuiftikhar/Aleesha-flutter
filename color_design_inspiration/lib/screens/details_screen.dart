import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/inspiration.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class DetailsScreen extends StatelessWidget {
  final InspirationItem item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () => _showFullScreenImage(context),
                child: Hero(
                  tag: item.id,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isFavorite(item.id);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    color: isFav ? Colors.red : Colors.white,
                    onPressed: () => provider.toggleFavorite(item.id),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.category.toString().split('.').last,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Color Palette',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: item.colors.map((colorStr) {
                        final color = Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
                        return Expanded(
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Center(
                              child: Text(
                                colorStr,
                                style: TextStyle(
                                  color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: item.tags.map((tag) => Chip(
                        label: Text('#$tag'),
                        backgroundColor: AppColors.cardBackground,
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMoodboardPicker(context),
        label: const Text('Add to Moodboard'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: CachedNetworkImage(imageUrl: item.imageUrl),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoodboardPicker(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Save to Moodboard', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (provider.moodboards.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No moodboards yet. Create one!'),
              )),
            ...provider.moodboards.map((mb) => ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text(mb.name),
              trailing: mb.itemIds.contains(item.id) 
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.add_circle_outline),
              onTap: () {
                provider.addToMoodboard(mb.id, item.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to ${mb.name}')),
                );
              },
            )),
            ListTile(
              leading: const Icon(Icons.add, color: AppColors.accent),
              title: const Text('Create New Moodboard', style: TextStyle(color: AppColors.accent)),
              onTap: () {
                Navigator.pop(context);
                _showCreateMoodboardDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateMoodboardDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Moodboard'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false).createMoodboard(controller.text);
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
