import 'package:flutter/material.dart';

void main() => runApp(const MusicPlayerApp());

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern Indigo/Violet Accent
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF030712), // Deep luxurious slate black
        fontFamily: 'Roboto',
      ),
      home: const MusicHomeScreen(),
    );
  }
}

class MusicHomeScreen extends StatefulWidget {
  const MusicHomeScreen({super.key});

  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> {
  double _currentSliderValue = 135.0; // 2:15
  final double _totalDurationValue = 240.0; // 4:00
  bool isPlaying = true;
  bool isFavorite = true;
  bool isShuffle = false;
  bool isRepeat = false;

  String _formatTime(double seconds) {
    int minutes = seconds.floor() ~/ 60;
    int remainingSeconds = seconds.floor() % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28, color: Colors.white70),
          onPressed: () {},
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'PLAYING FROM ALBUM',
              style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: Colors.white38, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              'Aura Soundscape',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 22, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1B4B), // Deep Indigo ambient glow at top
              Color(0xFF030712), // Rich Pitch Black bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Premium Album Art Container with Multi-Layer Shadow & Rounded Borders
                Center(
                  child: Container(
                    height: 310,
                    width: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 5,
                          offset: const Offset(0, 20),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Simulated Audio Visualizer Waves
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    16,
                        (index) => Container(
                      width: 3,
                      height: (index % 3 == 0) ? 18.0 : (index % 2 == 0 ? 12.0 : 6.0),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index.isEven ? const Color(0xFF6366F1) : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Frosted Control & Info Sheet Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      // Song Title, Artist & Favorite Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Midnight Melodies',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Aura Soundscape • 2026 Remaster',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFavorite ? const Color(0xFF6366F1) : Colors.white60,
                              size: 26,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress Slider & Timestamps
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                              activeTrackColor: const Color(0xFF6366F1),
                              inactiveTrackColor: Colors.white10,
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: _currentSliderValue,
                              min: 0,
                              max: _totalDurationValue,
                              onChanged: (value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatTime(_currentSliderValue), style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500)),
                                Text(_formatTime(_totalDurationValue), style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Main Playback Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shuffle_rounded,
                              color: isShuffle ? const Color(0xFF6366F1) : Colors.white38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                isShuffle = !isShuffle;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 34),
                            onPressed: () {},
                          ),
                          // Play/Pause Action Button with Glow
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            child: Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF6366F1),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.4),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 34),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.repeat_rounded,
                              color: isRepeat ? const Color(0xFF6366F1) : Colors.white38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                isRepeat = !isRepeat;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Footer Options (Lyrics & AirPlay/Devices)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Row(
                          children: const [
                            Icon(Icons.devices_rounded, size: 16, color: Colors.white38),
                            SizedBox(width: 6),
                            Text('Aura Pods Pro', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.lyrics_rounded, color: Colors.white38, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}