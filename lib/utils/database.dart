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
  ) async {
    _user.doc(LocalDB.uid).collection('sounds').doc(path).delete();
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    _firebaseStorage
        .ref()
        .child('Sounds')
        .child(
          title + '.' + date,
        )
        .delete();
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

// static String? text;
//
// static Future<void> readItem({
//   required uid,
//   required item,
// }) async {
//   _user.doc(uid).get().then((snapshot) {
//     text = snapshot.data()?[item];
//   });
// }
//
// static String? phone;
//
// static Future<void> read(String name) async {
//   _user.doc(ModelUser.uid).get().then(
//     (snapshot) {
//       phone = snapshot.data()?[name];
//     },
//   );
// }
//
// static String? getPhone() {
//   read('phone');
//   return phone;
// }

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference _mainCollection = _firestore.collection('notes');
//
// class Database {
//   static String? userUid;
//
//   static String? itemId;
//   static Future<void> getId () async {
//     DocumentReference documentReferencer =
//     _mainCollection.doc(userUid).collection('items').doc();
//     itemId = _mainCollection.id;
//   }
//
//   static Future<void> addItem({
//     required String title,
//     required String description,
//   }) async {
//     DocumentReference documentReferencer =
//     _mainCollection.doc(userUid).collection('items').doc();
//
//     Map<String, dynamic> data = <String, dynamic>{
//       "title": title,
//       "description": description,
//     };
//
//     await documentReferencer
//         .set(data)
//         .whenComplete(() => print("Note item added to the database"))
//         .catchError((e) => print(e));
//   }
//
//   static Future<void> updateItem({
//     required String title,
//     required String description,
//     // required String docId,
//   }) async {
//     DocumentReference documentReferencer =
//     _mainCollection.doc(userUid).collection('items').doc(itemId);
//
//     Map<String, dynamic> data = <String, dynamic>{
//       "title": title,
//       "description": description,
//     };
//
//     await documentReferencer
//         .update(data)
//         .whenComplete(() => print("Note item updated in the database"))
//         .catchError((e) => print(e));
//   }
//
//   static Stream<QuerySnapshot> readItems() {
//     CollectionReference notesItemCollection =
//     _mainCollection.doc(userUid).collection('items');
//
//     return notesItemCollection.snapshots();
//   }
//
//   static Future<void> deleteItem({
//     required String docId,
//   }) async {
//     DocumentReference documentReferencer =
//     _mainCollection.doc(userUid).collection('items').doc(docId);
//
//     await documentReferencer
//         .delete()
//         .whenComplete(() => print('Note item deleted from the database'))
//         .catchError((e) => print(e));
//   }
// }
