import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class ProfileChangeImageRequest extends ProfileEvent {

}

class ProfileOpenImagePicker extends ProfileEvent {
  final File image;

  ProfileOpenImagePicker({required this.image});
}

class ProfileProvideImagePath extends ProfileEvent {}

class ProfileChangeNumber extends ProfileEvent {}

class ProfileSaveChanges extends ProfileEvent {}