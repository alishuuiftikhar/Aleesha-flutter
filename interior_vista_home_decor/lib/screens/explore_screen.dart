import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/app_data.dart';
import '../widgets/furniture_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  bool _isError1 = false;
  bool _isError2 = false;

  @override
  void initState() {
    super.initState();
    
    // Stable Video Links for Home Decor
    _controller1 = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'), // Placeholder stable link
    )..initialize().then((_) {
        _controller1.setLooping(true);
        _controller1.setVolume(0);
        setState(() {});
      }).catchError((error) {
        setState(() => _isError1 = true);
      });

    _controller2 = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'), // Placeholder stable link
    )..initialize().then((_) {
        _controller2.setLooping(true);
        _controller2.setVolume(0);
        setState(() {});
      }).catchError((error) {
        setState(() => _isError2 = true);
      });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<FurnitureItem> trendingItems = List.from(AppData.allItems)..shuffle();
    trendingItems = trendingItems.take(20).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Style Inspiration',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFF06292)),
            ),
            const Text('Cinematic home tours and decor ideas', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            
            // Video Carousel
            SizedBox(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildVideoPlayer(_controller1, 'Minimalist Loft', _isError1),
                  _buildVideoPlayer(_controller2, 'Modern Studio', _isError2),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            const Text('Curated Collection', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            AnimationLimiter(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: trendingItems.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    columnCount: 2,
                    child: FadeInAnimation(
                      child: ScaleAnimation(
                        child: FurnitureCard(item: trendingItems[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller, String title, bool isError) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withAlpha(30),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isError)
              const Center(child: Text('Video unavailable', style: TextStyle(color: Colors.white70)))
            else if (controller.value.isInitialized)
              VideoPlayer(controller)
            else
              const Center(child: CircularProgressIndicator(color: Color(0xFFF06292))),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(180)],
                ),
              ),
            ),
            
            // Text
            Positioned(
              bottom: 30,
              left: 25,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Play Button
            if (!isError)
              Center(
                child: IconButton(
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white.withAlpha(200),
                    size: 70,
                  ),
                  onPressed: () => setState(() {
                    controller.value.isPlaying ? controller.pause() : controller.play();
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
