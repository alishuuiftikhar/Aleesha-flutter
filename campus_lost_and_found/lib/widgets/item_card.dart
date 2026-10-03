import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';
import '../theme/app_theme.dart';

class ItemCard extends StatelessWidget {
  final LostFoundItem item;
  final double? width;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: item.imagePath != null
                    ? _buildImage(item.imagePath!)
                    : _buildPlaceholder(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d').format(item.dateTime),
                          style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                        ),
                        _buildStatusBadge(),
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

  Widget _buildImage(String path) {
    if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
      return Image.network(
        path,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildPlaceholder(),
      );
    }
    return Image.file(
      File(path),
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.secondary.withOpacity(0.1),
      child: Center(
        child: Icon(
          item.type == ReportType.lost ? Icons.help_outline : Icons.search,
          color: AppColors.secondary,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    switch (item.status) {
      case ItemStatus.reported:
        color = AppColors.highlight;
        break;
      case ItemStatus.returned:
        color = AppColors.success;
        break;
      case ItemStatus.claimRequested:
        color = AppColors.accent;
        break;
      default:
        color = AppColors.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        item.type == ReportType.lost ? 'LOST' : 'FOUND',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
