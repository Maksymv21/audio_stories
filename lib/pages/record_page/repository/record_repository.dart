import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class RecordRepository {
  final Codec _codec = Codec.aacMP4;
  final String _path = 'temp.aac';
  FlutterSoundPlayer? _player;
  FlutterSoundRecorder? _recorder;

  bool get isStoppedPlayer => _player!.isStopped;

  bool get isStoppedRecorder => _recorder!.isStopped;

  Future openSession() async {
    _player = FlutterSoundPlayer();
    _recorder = FlutterSoundRecorder();
    _player!.openAudioSession();
  }

  Future openTheRecorder() async {
    await _recorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
    );
    await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 10));
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
  }

  Future close() async {
    _player!.closeAudioSession();
    _player = null;
    _recorder!.closeAudioSession();
    _recorder = null;
  }

  void record(void Function() foo) {
    Directory directory = Directory(path.dirname(_path));
    if (!directory.existsSync()) {
      directory.createSync();
    }
    _recorder!
        .startRecorder(
          toFile: _path,
          codec: _codec,
        )
        .then((value) => foo);
  }

  void stopRecord(void Function() foo) async {
    await _recorder!.stopRecorder().then((value) => foo);
  }

  void play(void Function() foo) {
    _player!
        .startPlayer(fromURI: _path, whenFinished: foo)
        .then((value) => foo);
  }

  void stopPlayer(void Function() foo) {
    _player!.stopPlayer().then((value) => foo);
  }
}
