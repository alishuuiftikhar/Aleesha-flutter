import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';
import '../models/claim.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';
import 'image_view_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final LostFoundItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(context),
                  const Divider(height: 40),
                  _buildDescription(context),
                  const SizedBox(height: 24),
                  _buildLocationInfo(context),
                  const SizedBox(height: 24),
                  _buildMatchingSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {
            if (item.imagePath != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageViewScreen(imagePath: item.imagePath!),
                ),
              );
            }
          },
          child: Hero(
            tag: item.imagePath ?? item.id,
            child: item.imagePath != null
                ? _buildImage(item.imagePath!)
                : Container(
                    color: AppColors.secondary.withOpacity(0.2),
                    child: const Icon(Icons.image_outlined, size: 80, color: AppColors.secondary),
                  ),
          ),
        ),
      ),
      actions: [
        Consumer<AppProvider>(
          builder: (context, provider, child) {
            final isFav = provider.favoriteIds.contains(item.id);
            return IconButton(
              icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border, color: AppColors.accent),
              onPressed: () async => await provider.toggleFavorite(item.id),
            );
          },
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    return Image.file(File(path), fit: BoxFit.cover);
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (item.type == ReportType.lost ? AppColors.error : AppColors.success).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.type == ReportType.lost ? 'LOST' : 'FOUND',
                style: TextStyle(
                  color: item.type == ReportType.lost ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              item.category.name.toUpperCase(),
              style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          item.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Reported on ${DateFormat('MMMM dd, yyyy').format(item.dateTime)} at ${DateFormat('jm').format(item.dateTime)}',
          style: const TextStyle(color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(item.description, style: const TextStyle(fontSize: 16, height: 1.5)),
        const SizedBox(height: 16),
        const Text('Identifying Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(item.identifyingDetails, style: const TextStyle(fontSize: 16, height: 1.5)),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.location),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingSection(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final matches = provider.findMatches(item);

    if (matches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40),
        const Text('Potential Matches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            itemBuilder: (context, index) => ItemCard(
              item: matches[index],
              width: 160,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemDetailScreen(item: matches[index])),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isMyReport = item.reporterId == provider.currentUserId;
    
    if (isMyReport) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Report'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                  onPressed: () {
                    // Navigate to Edit
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () {
                  _confirmDelete(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    if (item.type == ReportType.lost) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _showContactDialog(context),
            child: const Text('I found this item!'),
          ),
        ),
      );
    }

    // Claim request for Found items
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showClaimDialog(context),
          child: const Text('This is mine! Claim it'),
        ),
      ),
    );
  }

  void _showClaimDialog(BuildContext context) {
    final TextEditingController proofController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide some proof that this item belongs to you (e.g., unique marks, serial number, password hints).'),
            const SizedBox(height: 16),
            TextField(
              controller: proofController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter proof here...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (proofController.text.isNotEmpty) {
                final claim = ItemClaim(
                  id: const Uuid().v4(),
                  itemId: item.id,
                  claimantId: Provider.of<AppProvider>(context, listen: false).currentUserId,
                  claimDate: DateTime.now(),
                  proofDescription: proofController.text,
                );
                await Provider.of<AppProvider>(context, listen: false).addClaim(claim);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Claim request submitted successfully!')),
                  );
                }
              }
            },
            child: const Text('Submit Claim'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Reporter'),
        content: const Text('Do you want to notify the owner that you found their item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Owner has been notified!')),
              );
            },
            child: const Text('Notify Owner'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report?'),
        content: const Text('Are you sure you want to permanently delete this report?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await Provider.of<AppProvider>(context, listen: false).deleteItem(item.id);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
