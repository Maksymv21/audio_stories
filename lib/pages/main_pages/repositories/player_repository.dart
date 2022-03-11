import 'package:flutter_sound/public/flutter_sound_player.dart';

class PlayerRepository {
  FlutterSoundPlayer? _player;

  Stream<PlaybackDisposition>? get onProgress => _player!.onProgress;

  Future openSession() async {
    _player = FlutterSoundPlayer();
    _player!.openAudioSession();
    await _player?.setSubscriptionDuration(
      const Duration(
        milliseconds: 50,
      ),
    );
  }

  Future close() async {
    _player!.closeAudioSession();
    _player = null;
  }

  Future<void> play(String url, void Function() foo) async {
    await _player!
        .startPlayer(fromURI: url, whenFinished: foo)
        .then((value) => foo);
  }

  void pausePlayer(void Function() foo) {
    _player!.pausePlayer().then((value) => foo);
  }

  void resumePlayer(void Function() foo) {
    _player!.resumePlayer().then((value) => foo);
  }

  Future<void> seek(int ms) async {
    await _player!.seekToPlayer(Duration(milliseconds: ms));
  }
}