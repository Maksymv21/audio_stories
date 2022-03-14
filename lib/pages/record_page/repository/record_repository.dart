import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';

class RecordRepository {
  final Codec _codec = Codec.aacADTS;
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
    await _player?.setSubscriptionDuration(
      const Duration(
        milliseconds: 50,
      ),
    );
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

  Future<void> play(void Function() foo) async {
    await _player!
        .startPlayer(fromURI: _path, whenFinished: foo)
        .then((value) => foo);
  }

  void pausePlayer(void Function() foo) {
    _player!.pausePlayer().then((value) => foo);
  }

  void resumePlayer(void Function() foo) {
    _player!.resumePlayer().then((value) => foo);
  }

  Future<void> uploadSound(
    String title,
    double time,
    Timestamp date,
  ) async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    Reference reference = _firebaseStorage
        .ref()
        .child('Sounds')
        .child(LocalDB.uid.toString())
        .child(
          title + '.' + date.toString(),
        );

    File sound = await File(_path!).create();

    final int length = sound.lengthSync();

    await reference.putFile(sound);
    String downloadUrl = await reference.getDownloadURL();

    List<String> search = [];
    for (int i = 1; i < title.length + 1; i++) {
      search.add(title.substring(0, i).toLowerCase());
    }

    Database.createOrUpdateSound({
      'song': downloadUrl,
      'title': title,
      'time': time,
      'date': date,
      'deleted': false,
      'memory': length,
      'search': search,
    });

    Database.createOrUpdate({
      'uid': LocalDB.uid,
      'totalMemory': FieldValue.increment(length),
    });
  }

  Future<void> seek(int ms) async {
    await _player!.seekToPlayer(Duration(milliseconds: ms));
  }
}
