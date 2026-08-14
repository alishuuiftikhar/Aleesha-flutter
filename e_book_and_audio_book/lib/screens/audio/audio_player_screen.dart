import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book_model.dart';
import '../../database/database_helper.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Book book;
  const AudioPlayerScreen({super.key, required this.book});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    
    try {
      // Mock audio source - in real app use widget.book.contentPath
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      )));

      final progress = await _dbHelper.getAudioProgress(widget.book.id!);
      if (progress != null) {
        _player.seek(Duration(seconds: progress['position_seconds']));
      }

      _player.positionStream.listen((pos) {
        if (_player.duration != null) {
          _dbHelper.updateAudioProgress(
            widget.book.id!,
            pos.inSeconds,
            _player.duration!.inSeconds,
          );
        }
      });
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCover(),
            const SizedBox(height: 40),
            _buildInfo(),
            const SizedBox(height: 40),
            _buildSlider(),
            const SizedBox(height: 40),
            _buildControls(),
            const SizedBox(height: 40),
            _buildExtraControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          'https://via.placeholder.com/250x250?text=AudioBook',
          height: 250,
          width: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      children: [
        Text(
          widget.book.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          widget.book.author,
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = _player.duration ?? Duration.zero;
        return Column(
          children: [
            Slider(
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (val) {
                _player.seek(Duration(seconds: val.toInt()));
              },
              activeColor: AppTheme.primaryColor,
              inactiveColor: AppTheme.secondaryColor.withOpacity(0.3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position)),
                  Text(_formatDuration(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, size: 40),
          onPressed: () => _player.seek(_player.position - const Duration(seconds: 10)),
        ),
        StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
              return const CircularProgressIndicator();
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_circle_filled, size: 80, color: AppTheme.primaryColor),
                onPressed: _player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_filled, size: 80, color: AppTheme.primaryColor),
                onPressed: _player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay_circle_filled, size: 80, color: AppTheme.primaryColor),
                onPressed: () => _player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, size: 40),
          onPressed: () => _player.seek(_player.position + const Duration(seconds: 10)),
        ),
      ],
    );
  }

  Widget _buildExtraControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.speed), onPressed: () {}),
        IconButton(icon: const Icon(Icons.playlist_play), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
