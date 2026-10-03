import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';
import 'author_profile_screen.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  double _scrollProgress = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollProgress = _scrollController.offset / _scrollController.position.maxScrollExtent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'img-${widget.article.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.article.imageUrl ?? 'https://via.placeholder.com/600x400',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.primary,
                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primary,
                    child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  Share.share('Check out this article: ${widget.article.title}');
                },
              ),
              Consumer<AppProvider>(
                builder: (context, provider, child) {
                  final isBookmarked = provider.bookmarks.any((e) => e.id == widget.article.id);
                  return IconButton(
                    icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: () {
                      provider.toggleBookmark(widget.article);
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.article.categoryName?.toUpperCase() ?? 'NEWS',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM dd, yyyy').format(widget.article.createdAt),
                        style: TextStyle(color: AppColors.text.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorProfileScreen(
                            authorId: widget.article.authorId,
                            authorName: widget.article.authorName ?? 'Unknown',
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(widget.article.authorName?[0] ?? 'A', style: const TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.article.authorName ?? 'Nova Staff',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, decoration: TextDecoration.underline),
                            ),
                            Text(
                              '${widget.article.readingTime} min read',
                              style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 40),
                  Text(
                    widget.article.content,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.text,
                      height: 1.6,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildRelatedArticles(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LinearProgressIndicator(
        value: _scrollProgress.clamp(0.0, 1.0),
        backgroundColor: Colors.transparent,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
        minHeight: 4,
      ),
    );
  }

  Widget _buildRelatedArticles() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final related = provider.articles
            .where((a) => a.categoryId == widget.article.categoryId && a.id != widget.article.id)
            .take(3)
            .toList();

        if (related.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONTINUE READING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.secondary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            ...related.map((article) => ArticleCard(article: article)).toList(),
          ],
        );
      },
    );
  }
}
