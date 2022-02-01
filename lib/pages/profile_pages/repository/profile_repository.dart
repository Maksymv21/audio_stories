import 'dart:io';

import 'package:audio_stories/pages/profile_pages/models/profile_model.dart';
import 'package:audio_stories/utils/database.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  final FirebaseStorage _firebaseStorage;

  ProfileRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
  }

  Future<ProfileModel> uploadImage(File _image) async {
    Reference reference = _firebaseStorage.ref().child(
      ProfileModel().uid.toString(),
    );

    await reference.putFile(_image);
    String downloadUrl = await reference.getDownloadURL();

    Database.createOrUpdate(
        {'uid': ProfileModel().uid, 'imageURL': downloadUrl});
    return ProfileModel(imageURL: downloadUrl);
  }
}
