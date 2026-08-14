import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'video_player_screen.dart';

class CineHomeScreen extends StatefulWidget {
  const CineHomeScreen({super.key});

  @override
  State<CineHomeScreen> createState() => _CineHomeScreenState();
}

class _CineHomeScreenState extends State<CineHomeScreen> {
  final ApiService _apiService = ApiService();
  
  // Restored movie categories
  final List<String> _allCategories = [
    'Popular', 'Trending', 'Sci-Fi', 'Action', 'Comedy', 
    'Horror', 'Thriller', 'Adventure', 'Animation', 'Punjabi', 
    'Drama', 'Family', 'Crime', 'Mystery', 'Documentary', 'Fantasy'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroSection()),
          
          for (String category in _allCategories)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(category),
                  _buildMovieHorizontalList(category),
                  const SizedBox(height: 15),
                ],
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          height: 600,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1200&auto=format&fit=crop'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.1, 0.4, 0.7, 1.0],
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'INTERSTELLAR',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sci-Fi • Adventure • Cinematic Discovery',
                style: TextStyle(color: Color(0xFFC4B5FD), fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoPlayerScreen(title: 'INTERSTELLAR')));
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 32),
                label: const Text('WATCH NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  elevation: 12,
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CINEPULSE',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, 
                    fontSize: 30, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 2
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.notifications_none_rounded, color: Color(0xFFC4B5FD), size: 24),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieHorizontalList(String category) {
    return SizedBox(
      height: 280,
      child: FutureBuilder<List<Movie>>(
        future: _apiService.getMoviesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Loading cinematic content...', style: TextStyle(color: Colors.grey)));
          }
          
          final movies = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const Text(
            'See All',
            style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: isDark ? const Color(0xFF18181B) : Colors.grey[300]!,
        highlightColor: isDark ? const Color(0xFF27272A) : Colors.grey[100]!,
        child: Container(
          width: 170,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white, 
            borderRadius: BorderRadius.circular(24)
          ),
        ),
      ),
    );
  }
}
