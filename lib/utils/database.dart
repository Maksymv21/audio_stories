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
          path,
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

    if (map.containsValue(true)) {
      final DocumentReference document = FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .doc(map['id']);
      await document.get().then<dynamic>((
        DocumentSnapshot snapshot,
      ) async {
        dynamic data = snapshot.data;
        if (data()['compilations'] != null) {
          List compilations = data()['compilations'];
          for (int i = 0; i < compilations.length; i++) {
            final DocumentReference documentCompilation = FirebaseFirestore
                .instance
                .collection('users')
                .doc(LocalDB.uid)
                .collection('compilations')
                .doc(compilations[i]);
            await documentCompilation.get().then<dynamic>((
              DocumentSnapshot snapshot,
            ) {
              deleteSoundInCompilation(
                {
                  'sounds': FieldValue.arrayRemove([map['id']]),
                },
                compilations[i],
                map['id'],
              );
            });
          }
        }
      });
      createOrUpdateSound({
        'id': map['id'],
        'compilations': [],
      });
    }
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
      ) {
        createOrUpdateSound({
          'id': map['sounds'][i],
          'compilations': FieldValue.arrayUnion([map['id']]),
        });
      });
    }
  }

  static Future deleteSoundInCompilation(
    Map<String, dynamic> map,
    String id,
    String soundId,
  ) async {
    _user.doc(LocalDB.uid).collection('compilations').doc(id).set(
          map,
          SetOptions(
            merge: true,
          ),
        );

    final DocumentReference document = FirebaseFirestore.instance
        .collection('users')
        .doc(LocalDB.uid)
        .collection('sounds')
        .doc(soundId);
    await document.get().then<dynamic>((
      DocumentSnapshot snapshot,
    ) {
      createOrUpdateSound({
        'id': soundId,
        'compilations': FieldValue.arrayRemove([id]),
      });
    });
  }

  static Future deleteCompilation(Map<String, dynamic> map) async {
    for (int i = 0; i < map['sounds'].length; i++) {
      final DocumentReference document = FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .doc(map['sounds'][i]);
      await document.get().then<dynamic>((
        DocumentSnapshot snapshot,
      ) {
        createOrUpdateSound({
          'id': map['sounds'][i],
          'compilations': FieldValue.arrayRemove([map['id']]),
        });
      });
    }

    _user.doc(LocalDB.uid).collection('compilations').doc(map['id']).delete();

    _storage
        .ref()
        .child('Compilations')
        .child(LocalDB.uid.toString())
        .child(map['id'])
        .delete();
  }
}
