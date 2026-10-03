import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/magazine.dart';
import '../utils/constants.dart';

class MagazineDetailsScreen extends StatelessWidget {
  final Magazine magazine;

  const MagazineDetailsScreen({super.key, required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: magazine.coverUrl ?? 'https://via.placeholder.com/600x800',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.highlight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PREMIUM EDITION',
                          style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMMM yyyy').format(magazine.issueDate),
                        style: TextStyle(color: AppColors.text.withOpacity(0.5), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    magazine.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 2,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    magazine.description ?? 'Immerse yourself in this months premier edition of Nova Global. Featuring exclusive interviews, deep-dive investigations, and stunning photography from around the world.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.text.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'IN THIS ISSUE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildIssueHighlight('THE FUTURE OF GLOBAL FINANCE', 'Elena Richardson'),
                  _buildIssueHighlight('THE QUANTUM REVOLUTION', 'Marcus Thorne'),
                  _buildIssueHighlight('CLIMATE CHANGE: A NEW HOPE', 'Sarah Jenkins'),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'READ DIGITAL EDITION',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueHighlight(String title, String author) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
                Text(
                  'BY $author',
                  style: TextStyle(fontSize: 10, color: AppColors.text.withOpacity(0.5), letterSpacing: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
