import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/app_colors.dart';

class SoundItem {
  final String name;
  final String icon;
  final String url;
  final Color color;
  bool isPlaying;
  double volume;
  AudioPlayer? player;

  SoundItem({
    required this.name,
    required this.icon,
    required this.url,
    required this.color,
    this.isPlaying = false,
    this.volume = 0.5,
  });
}

class NatureSoundsScreen extends StatefulWidget {
  const NatureSoundsScreen({super.key});

  @override
  State<NatureSoundsScreen> createState() => _NatureSoundsScreenState();
}

class _NatureSoundsScreenState extends State<NatureSoundsScreen> {
  final List<SoundItem> _sounds = [
    SoundItem(name: "Rain", icon: "🌧️", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", color: Colors.blue),
    SoundItem(name: "Forest", icon: "🌲", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", color: Colors.green),
    SoundItem(name: "Ocean", icon: "🌊", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", color: Colors.cyan),
    SoundItem(name: "Fire", icon: "🔥", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", color: Colors.orange),
    SoundItem(name: "Birds", icon: "🐦", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", color: Colors.lime),
    SoundItem(name: "Wind", icon: "💨", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", color: Colors.blueGrey),
  ];

  @override
  void dispose() {
    for (var sound in _sounds) {
      sound.player?.dispose();
    }
    super.dispose();
  }

  void _toggleSound(SoundItem sound) async {
    if (sound.isPlaying) {
      await sound.player?.pause();
    } else {
      if (sound.player == null) {
        sound.player = AudioPlayer();
        await sound.player?.setReleaseMode(ReleaseMode.loop);
        await sound.player?.setSource(UrlSource(sound.url));
      }
      await sound.player?.setVolume(sound.volume);
      await sound.player?.resume();
    }
    setState(() {
      sound.isPlaying = !sound.isPlaying;
    });
  }

  void _updateVolume(SoundItem sound, double volume) async {
    setState(() {
      sound.volume = volume;
    });
    await sound.player?.setVolume(volume);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Nature Sounds')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Create your personal ambient mix by combining multiple sounds.",
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? AppColors.darkText : AppColors.secondary),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: _sounds.length,
              itemBuilder: (context, index) {
                final sound = _sounds[index];
                return _buildSoundCard(sound, isDark);
              },
            ),
          ),
          if (_sounds.any((s) => s.isPlaying))
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: AppColors.primary),
                  const SizedBox(width: 10),
                  const Text("Mixer is active", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      for (var s in _sounds) {
                        if (s.isPlaying) _toggleSound(s);
                      }
                    },
                    child: const Text("Stop All", style: TextStyle(color: Colors.red)),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSoundCard(SoundItem sound, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: sound.isPlaying 
            ? sound.color.withOpacity(isDark ? 0.2 : 0.1) 
            : (isDark ? AppColors.darkCard : AppColors.cardBackground),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: sound.isPlaying ? sound.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(sound.icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(
            sound.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (sound.isPlaying)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  value: sound.volume,
                  onChanged: (val) => _updateVolume(sound, val),
                  activeColor: sound.color,
                ),
              ),
            ),
          const SizedBox(height: 5),
          IconButton(
            icon: Icon(
              sound.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: sound.isPlaying ? sound.color : AppColors.primary.withOpacity(0.5),
              size: 40,
            ),
            onPressed: () => _toggleSound(sound),
          ),
        ],
      ),
    );
  }
}
