import 'package:audio_stories/utils/local_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _user = FirebaseFirestore.instance.collection('users');

class Database {
  static Future createOrUpdate(Map<String, dynamic> map) async {
    _user.doc(map['uid']).set(
          map,
          SetOptions(
            merge: true,
          ),
        );
  }

  static Future delete(String uid) async {
    _user.doc(uid).delete();
  }

  static Future deleteSound(
    String path,
    String title,
    String date,
    int memory,
  ) async {
    _user.doc(LocalDB.uid).collection('sounds').doc(path).delete();
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    _firebaseStorage
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

  static Future createOrUpdateSound(Map<String, dynamic> map,
      {String? id}) async {
    final _sounds = _user.doc(LocalDB.uid).collection('sounds');
    _sounds.doc(id).set(
          map,
          SetOptions(
            merge: true,
          ),
        );
  }
}
