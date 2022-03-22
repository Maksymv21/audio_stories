import 'dart:io';

import 'package:audio_stories/utils/local_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final CollectionReference _user =
    FirebaseFirestore.instance.collection('users');
final FirebaseStorage _storage = FirebaseStorage.instance;

class Database {
  static Future createOrUpdate(
    Map<String, dynamic> map,
  ) async {
    _user.doc(map['uid']).set(
          map,
          SetOptions(
            merge: true,
          ),
        );
  }

  static Future delete(String uid) async {
    _user.doc(uid).delete();

    final QuerySnapshot snapshotSounds =
        await _user.doc(uid).collection('sounds').get();
    for (QueryDocumentSnapshot doc in snapshotSounds.docs) {
      await doc.reference.delete();
    }

    final QuerySnapshot snapshotCompilations =
        await _user.doc(uid).collection('compilations').get();
    for (QueryDocumentSnapshot doc in snapshotCompilations.docs) {
      await doc.reference.delete();
    }
  }

  static Future deleteSound(
    String path,
    String title,
    String date,
    int memory,
  ) async {
    _user.doc(LocalDB.uid).collection('sounds').doc(path).delete();
    _storage
        .ref()
        .child('Sounds')
        .child(LocalDB.uid.toString())
        .child(
          title + '.' + date,
        )
        .delete();

    Database.createOrUpdate({
      'uid': LocalDB.uid,
      'totalMemory': FieldValue.increment(-memory),
    });
  }

  static Future createOrUpdateSound(Map<String, dynamic> map) async {
    final CollectionReference _sounds =
        _user.doc(LocalDB.uid).collection('sounds');
    _sounds.doc(map['id']).set(
          map,
          SetOptions(
            merge: true,
          ),
        );
  }

  static Future createOrUpdateCompilation(Map<String, dynamic> map,
      {File? image}) async {
    if (image != null) {
      Reference reference = _storage
          .ref()
          .child('Compilations')
          .child(LocalDB.uid.toString())
          .child(map['id']);

      await reference.putFile(image);
      String downloadUrl = await reference.getDownloadURL();

      map.addAll({'image': downloadUrl});
    }

    _user.doc(LocalDB.uid).collection('compilations').doc(map['id']).set(
          map,
          SetOptions(
            merge: true,
          ),
        );

    for (int i = 0; i < map['sounds'].length; i++) {
      final DocumentReference document = FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .doc(map['sounds'][i]);
      await document.get().then<dynamic>((
        DocumentSnapshot snapshot,
      ) async {
        dynamic data = snapshot.data;
        if (data()['compilations'] != null) {
          List compilations = data()['compilations'];
          if (!compilations.contains(map['id'])) {
            compilations.add(map['id']);
            createOrUpdateSound({
              'id': map['sounds'][i],
              'compilations': compilations,
            });
          }
        } else {
          createOrUpdateSound({
            'id': map['sounds'][i],
            'compilations': [map['id']],
          });
        }
      });
    }
  }

  static Future deleteSoundInCompilation(
    Map<String, dynamic> map,
    String id,
  ) async {
    _user.doc(LocalDB.uid).collection('compilations').doc(id).set(
          map,
          SetOptions(
            merge: true,
          ),
        );
  }

  static Future deleteCompilation(Map<String, dynamic> map) async {
    _user.doc(LocalDB.uid).collection('compilations').doc(map['id']).delete();

    _storage
        .ref()
        .child('Compilations')
        .child(LocalDB.uid.toString())
        .child(map['id'])
        .delete();
  }
}
