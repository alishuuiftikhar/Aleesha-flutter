import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';
import 'article_details_screen.dart';
import 'category_articles_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 16),
                      ),
                      const Text(
                        'Nova Reader',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildCategoryBar(provider),
              if (provider.isLoading)
                SliverToBoxAdapter(child: _buildShimmerLoading())
              else if (provider.articles.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(provider))
              else ...[
                _buildTrendingSection(context, provider),
                _buildSportsPreview(context, provider),
                SliverToBoxAdapter(child: _buildSectionHeader('Latest Stories', () {})),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ArticleCard(article: provider.articles[index]),
                      childCount: provider.articles.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'NOVA NEWS',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCategoryBar(AppProvider provider) {
    if (provider.categories.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.categories.length,
          itemBuilder: (context, index) {
            final category = provider.categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryArticlesScreen(category: category),
                  ),
                );
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
                      ),
                      child: Icon(_getCategoryIcon(category.name), color: AppColors.secondary, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name.toUpperCase(),
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'world': return Icons.public;
      case 'technology': return Icons.biotech;
      case 'science': return Icons.science;
      case 'business': return Icons.business_center;
      case 'sports': return Icons.sports_basketball;
      case 'entertainment': return Icons.movie;
      case 'lifestyle': return Icons.spa;
      case 'education': return Icons.school;
      case 'travel': return Icons.flight;
      default: return Icons.newspaper;
    }
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'View All',
              style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context, AppProvider provider) {
    if (provider.trendingArticles.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Top Trends', () {}),
          SizedBox(
            height: 380,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: provider.trendingArticles.length,
              itemBuilder: (context, index) {
                final article = provider.trendingArticles[index];
                return _buildTrendingCard(context, article);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportsPreview(BuildContext context, AppProvider provider) {
    final sportsArticles = provider.articles.where((a) => a.categoryName?.toLowerCase() == 'sports').take(3).toList();
    if (sportsArticles.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Sports Highlights', () {
            final sportsCat = provider.categories.firstWhere((c) => c.name.toLowerCase() == 'sports');
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryArticlesScreen(category: sportsCat)));
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: sportsArticles.map((article) => ArticleCard(article: article)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(BuildContext context, dynamic article) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppProvider>(context, listen: false).addToHistory(article.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailsScreen(article: article)));
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'img-${article.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? 'https://via.placeholder.com/600x400',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.secondaryBackground,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.cardBackground,
                    child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primary, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      article.categoryName?.toUpperCase() ?? 'WORLD',
                      style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.secondary,
                        child: Text(article.authorName?[0] ?? 'N', style: const TextStyle(fontSize: 10, color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      Text(article.authorName ?? 'Nova Staff', style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryBackground,
      highlightColor: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(3, (index) => Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          )),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 80, color: AppColors.primary.withOpacity(0.2)),
          const SizedBox(height: 20),
          const Text('No Articles Yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => provider.loadInitialData(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
