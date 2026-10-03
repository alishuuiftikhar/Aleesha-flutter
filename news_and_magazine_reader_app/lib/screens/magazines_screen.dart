import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

import 'magazine_details_screen.dart';

class MagazinesScreen extends StatelessWidget {
  const MagazinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('MAGAZINES', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.magazines.isEmpty) {
            return const Center(child: Text('No magazines available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: provider.magazines.length,
            itemBuilder: (context, index) {
              final magazine = provider.magazines[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MagazineDetailsScreen(magazine: magazine)),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: magazine.coverUrl ?? 'https://via.placeholder.com/300x400',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      magazine.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 10, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMMM yyyy').format(magazine.issueDate),
                          style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
