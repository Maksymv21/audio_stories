import 'dart:async';
import 'dart:io';

import 'package:audio_stories/repositories/global_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/database.dart';
import '../../../../../utils/local_db.dart';

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
    _recorder!.openAudioSession();
    await _recorder!.setSubscriptionDuration(
      const Duration(
        milliseconds: 20,
      ),
    );
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

  Future<void> share() async {
    Share.shareFiles([_path!]);
  }

  Future<void> download(String name) async {
    File sound = await File(_path!).create();

    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    Reference reference = _firebaseStorage
        .ref()
        .child('Sounds')
        .child(LocalDB.uid.toString())
        .child(
          'forSave',
        );

    await reference.putFile(sound);
    String downloadUrl = await reference.getDownloadURL();

    await GlobalRepo.download(downloadUrl, name);

    reference.delete();
  }

  Future<void> uploadSound(
    String title,
    double time,
    Timestamp date,
    int memory,
    BuildContext context,
  ) async {
    File sound = await File(_path!).create();
    final int length = sound.lengthSync();

    if (memory + length <= 500000000) {
      FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
      Reference reference = _firebaseStorage
          .ref()
          .child('Sounds')
          .child(LocalDB.uid.toString())
          .child(
            title + '.' + date.toString(),
          );

      await reference.putFile(sound);
      String downloadUrl = await reference.getDownloadURL();

      List<String> search = [];
      for (int i = 1; i < title.length + 1; i++) {
        search.add(title.substring(0, i).toLowerCase());
      }

      const Uuid uuid = Uuid();
      final String id = uuid.v1();

      Database.createOrUpdateSound({
        'id': id,
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
    } else {
      SnackBar snackBar = const SnackBar(
        content: Text(
          'Закончилась память для сохранения аудио.'
          '\nДля увеличения памяти оформите подписку',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 4),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> seek(int ms) async {
    await _player!.seekToPlayer(Duration(milliseconds: ms));
  }
}
