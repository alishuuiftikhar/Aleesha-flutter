import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/article.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../screens/article_details_screen.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppProvider>(context, listen: false).addToHistory(article.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleDetailsScreen(article: article)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.05), width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.categoryName?.toUpperCase() ?? 'GENERAL',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          timeago.format(article.createdAt),
                          style: TextStyle(color: AppColors.text.withOpacity(0.5), fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        const CircleAvatar(radius: 1.5, backgroundColor: AppColors.accent),
                        const SizedBox(width: 8),
                        Text(
                          '${article.readingTime} min read',
                          style: TextStyle(color: AppColors.text.withOpacity(0.5), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                children: [
                  Hero(
                    tag: 'img-${article.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: article.imageUrl ?? 'https://via.placeholder.com/150',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.secondaryBackground,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.cardBackground,
                          child: const Icon(Icons.broken_image_outlined, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AppProvider>(context, listen: false).toggleBookmark(article);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: article.isBookmarked ? AppColors.highlight : AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
