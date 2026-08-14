import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final StorageService _storageService = StorageService();
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlist();
  }

  Future<void> _checkWatchlist() async {
    final status = await _storageService.isInWatchlist(widget.movie.id);
    setState(() => _isInWatchlist = status);
  }

  Future<void> _toggleWatchlist() async {
    await _storageService.toggleWatchlist(widget.movie);
    _checkWatchlist();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInWatchlist ? 'Removed from Watchlist' : 'Added to Watchlist'),
        backgroundColor: const Color(0xFF5B21B6),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 550,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF09090B),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.movie.id,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.movie.imageUrl, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF18181B),
                        child: const Icon(Icons.broken_image_outlined, size: 50, color: Color(0xFFC4B5FD)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFF09090B),
                            const Color(0xFF09090B).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.movie.title, 
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1, color: Colors.white)
                        )
                      ),
                      IconButton(
                        onPressed: _toggleWatchlist,
                        icon: Icon(_isInWatchlist ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFF8B5CF6), size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 6),
                      Text(widget.movie.rating, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                      const SizedBox(width: 20),
                      Text(widget.movie.releaseYear, style: const TextStyle(color: Color(0xFFC4B5FD), fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Storyline', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(
                    widget.movie.description, 
                    style: const TextStyle(color: Color(0xFFC4B5FD), height: 1.6, fontSize: 15)
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded, size: 30),
                    label: const Text('WATCH NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      shadowColor: const Color(0xFF5B21B6).withOpacity(0.5),
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
}
