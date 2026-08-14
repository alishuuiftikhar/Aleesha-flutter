import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/book_model.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Book? _currentBook;

  AudioPlayer get player => _player;
  Book? get currentBook => _currentBook;

  void playBook(Book book) async {
    _currentBook = book;
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
      )));
      _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
