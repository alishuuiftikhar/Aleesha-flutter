import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import '../widgets/article_card.dart';

class AuthorProfileScreen extends StatefulWidget {
  final String authorId;
  final String authorName;

  const AuthorProfileScreen({super.key, required this.authorId, required this.authorName});

  @override
  State<AuthorProfileScreen> createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Article> _authorArticles = [];
  bool _isLoading = true;
  Map<String, dynamic>? _authorData;

  @override
  void initState() {
    super.initState();
    _loadAuthorDetails();
  }

  Future<void> _loadAuthorDetails() async {
    try {
      // Get author profile data (bio, avatar)
      final response = await _supabaseService.getAuthors(query: widget.authorName);
      if (response.isNotEmpty) {
        _authorData = {
          'bio': response[0].bio,
          'avatar_url': response[0].avatarUrl,
        };
      }

      final articles = await _supabaseService.getArticles(authorId: widget.authorId);
      setState(() {
        _authorArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading author articles: $e');
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
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (_authorData?['avatar_url'] != null)
                    CachedNetworkImage(
                      imageUrl: _authorData!['avatar_url'],
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: AppColors.secondary),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.authorName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SENIOR EDITORIAL CONTRIBUTOR',
                          style: TextStyle(
                            color: AppColors.highlight.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BIOGRAPHY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _authorData?['bio'] ?? 'Elena is a dedicated journalist with a focus on uncovering hidden stories and providing deep analysis on global events. Her work has been featured in numerous international publications.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PUBLISHED WORK',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '${_authorArticles.length} ARTICLES',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (_authorArticles.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No articles found.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ArticleCard(article: _authorArticles[index]),
                  childCount: _authorArticles.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}
