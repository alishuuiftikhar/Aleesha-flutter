import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('BOOKMARKS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: AppColors.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No saved articles yet',
                    style: TextStyle(color: AppColors.primary.withOpacity(0.5), fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              return ArticleCard(article: provider.bookmarks[index]);
            },
          );
        },
      ),
    );
  }
}
