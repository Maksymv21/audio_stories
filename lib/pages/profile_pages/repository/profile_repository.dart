import 'dart:io';

import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  final FirebaseStorage _firebaseStorage;

  ProfileRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  Future<ProfileModel> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    return ProfileModel(avatar: File(image!.path));
  }

  Future<ProfileModel> uploadImage(File avatar) async {
    Reference reference = _firebaseStorage.ref().child('Images').child(
          LocalDB.uid.toString(),
        );

    await reference.putFile(avatar);
    String downloadUrl = await reference.getDownloadURL();

    Database.createOrUpdate(
        {'uid': LocalDB.uid, 'imageURL': downloadUrl});
    return ProfileModel(imageURL: downloadUrl);
  }

  Future<ProfileModel> saveName(String name) async {
    Database.createOrUpdate({'uid': LocalDB.uid, 'name': name});
    return ProfileModel(name: name);
  }
}
