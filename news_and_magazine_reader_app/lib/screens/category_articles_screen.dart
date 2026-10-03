import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../providers/app_provider.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';

class CategoryArticlesScreen extends StatefulWidget {
  final Category category;

  const CategoryArticlesScreen({super.key, required this.category});

  @override
  State<CategoryArticlesScreen> createState() => _CategoryArticlesScreenState();
}

class _CategoryArticlesScreenState extends State<CategoryArticlesScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryArticles();
  }

  Future<void> _loadCategoryArticles() async {
    setState(() => _isLoading = true);
    try {
      final results = await _supabaseService.getArticles(
        categoryId: widget.category.id,
      );
      setState(() {
        _articles = results;
      });
    } catch (e) {
      debugPrint('Error loading category articles: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      _getCategoryIcon(widget.category.name),
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (_articles.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper, size: 64, color: AppColors.primary.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Text(
                      'No stories found in ${widget.category.name}',
                      style: TextStyle(color: AppColors.text.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ArticleCard(article: _articles[index]),
                  childCount: _articles.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
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
}
