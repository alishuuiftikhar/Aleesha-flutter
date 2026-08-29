import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../utils/app_colors.dart';

class MeditationDetailScreen extends StatefulWidget {
  final MeditationSession session;
  const MeditationDetailScreen({super.key, required this.session});

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  bool _isPlaying = false;
  double _progress = 0.0;
  late int _remainingSeconds;
  late AudioPlayer _audioPlayer;
  
  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.session.durationMinutes * 60;
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  void _setupAudio() async {
    await _audioPlayer.setSource(UrlSource(widget.session.audioUrl));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
      _simulateProgress();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _simulateProgress() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isPlaying && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _progress = 1 - (_remainingSeconds / (widget.session.durationMinutes * 60));
        });
        _simulateProgress();
      } else if (_remainingSeconds == 0) {
        _completeSession();
      }
    });
  }

  void _completeSession() {
    Provider.of<AppState>(context, listen: false).completeSession(widget.session.durationMinutes);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session completed! Well done.')),
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'session-img-${widget.session.id}',
                child: Image.network(
                  widget.session.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.secondaryBackground.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.secondaryBackground,
                    child: const Icon(Icons.image_not_supported, color: AppColors.primary, size: 50),
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<AppState>(
                builder: (context, state, child) {
                  return IconButton(
                    icon: Icon(
                      widget.session.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.session.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () => state.toggleFavorite(widget.session.id),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.session.category,
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.session.durationMinutes} mins',
                        style: const TextStyle(color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.session.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.session.description,
                    style: const TextStyle(fontSize: 16, color: AppColors.secondary, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: AppColors.secondaryBackground,
                            color: AppColors.primary,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10),
                              iconSize: 32,
                              onPressed: () {},
                            ),
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: _togglePlay,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            IconButton(
                              icon: const Icon(Icons.forward_10),
                              iconSize: 32,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
