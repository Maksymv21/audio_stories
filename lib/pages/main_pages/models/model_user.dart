import 'package:audio_stories/utils/database.dart';

class ModelUser {
  // static Stream user = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(ModelUser.uid)
  //     .snapshots();

  static String? uid;
  static String? phoneNumber;
  static String profilePhoneNumber = '+380...';

  static void createUser() {
    Database.create(
      uid: uid,
      map: {'phone': phoneNumber},
    );
    if (phoneNumber != null) {
      profilePhoneNumber = phoneNumber!.substring(0, 3) +
          ' (' +
          phoneNumber!.substring(3, 6) +
          ') ' +
          phoneNumber!.substring(6, 9) +
          ' ' +
          phoneNumber!.substring(9, 11) +
          ' ' +
          phoneNumber!.substring(11, 13);
    }
  }

  static Future<void> createData(String title, String info) async {
    Database.create(uid: uid, map: {title: info});
  }

// static String? readName() {
//   name = Database.read(uid: uid)!['name'].toString();
//   return name;
// }
}

// static String loh() {
//   Database.readItem(uid: uid, item: "name");
//   return Database.text!;
// }
// static void readName () {
//   Database.read('name');
//   print(Database.phone);
// }
