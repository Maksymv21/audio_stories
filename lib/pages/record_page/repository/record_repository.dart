import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';

class RecordRepository {
  final Codec _codec = Codec.aacMP4;
  String? _path;
  FlutterSoundPlayer? _player;
  FlutterSoundRecorder? _recorder;

  Stream<RecordingDisposition>? get onProgress => _recorder!.onProgress;

  Stream<PlaybackDisposition>? get onProgressP => _player!.onProgress;

  FlutterSoundRecorder? get recorder => _recorder;

  Future openSession() async {
    _player = FlutterSoundPlayer();
    _recorder = FlutterSoundRecorder();
    _player!.openAudioSession();
  }

  Future close() async {
    _player!.closeAudioSession();
    _player = null;
    _recorder!.closeAudioSession();
    _recorder = null;
  }

  void record(void Function() foo) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = directory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    _path = filepath;
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

  void pausePlayer(void Function() foo) {
    _player!.pausePlayer().then((value) => foo);
  }

  Future<void> uploadSound() async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    Reference reference = _firebaseStorage.ref().child('Sounds').child(
          LocalDB.uid.toString() + 'sound',
        );

    File sound = await File(_path!).create();
    await reference.putFile(sound);
    String downloadUrl = await reference.getDownloadURL();

    Database.createOrUpdateSound({'song': downloadUrl});
  }
}
