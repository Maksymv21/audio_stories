import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class RecordRepository {
  final Codec _codec = Codec.aacMP4;
  final String _path = 'temp.aac';
  final FlutterSoundPlayer? _player = FlutterSoundPlayer();
  final FlutterSoundRecorder? _recorder = FlutterSoundRecorder();

  bool get isStoppedPlayer => _player!.isStopped;
  bool get isStoppedRecorder => _recorder!.isStopped;

  Future openSession() async {
    _player!.openAudioSession();
  }

  Future openTheRecorder() async {
    await _recorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
      //device: AudioDevice.speaker
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

    _recorder!.closeAudioSession();
  }

  void record() {
    Directory directory = Directory(path.dirname(_path));
    if (!directory.existsSync()) {
      directory.createSync();
    }
    _recorder!.startRecorder(
      toFile: _path,
      codec: _codec,
    );
  }

  void stopRecord() async {
    await _recorder!.stopRecorder();
  }

  void play(void Function() foo) {
    _player!.startPlayer(fromURI: _path, whenFinished: foo);
  }

  void stopPlayer() {
    _player!.stopPlayer();
  }


}
// FlutterSoundRecorder? _flutterSoundRecorder;
// bool _isRecording = false;
//
// bool get isRecording => _flutterSoundRecorder!.isRecording;
//
// Future init() async {
//   _flutterSoundRecorder = FlutterSoundRecorder();
//   final status = await Permission.microphone.request();
//   if (status != PermissionStatus.granted) {
//     throw RecordingPermissionException('Microphone permission not granted');
//   }
//
//   await _flutterSoundRecorder!.openAudioSession();
//   _isRecording = true;
// }
//
// void dispose() {
//   _flutterSoundRecorder!.closeAudioSession();
//   _flutterSoundRecorder = null;
//   _isRecording = false;
// }
//
// Future _record() async {
//   if (!_isRecording) return;
//   await _flutterSoundRecorder!.startRecorder(toFile: path);
// }
//
// Future _stop() async {
//   if (!_isRecording) return;
//   await _flutterSoundRecorder!.stopRecorder();
// }
//
// Future toggleRecording() async {
//   if (_flutterSoundRecorder!.isStopped) {
//     await _record();
//   } else {
//     await _stop();
//   }
// }
