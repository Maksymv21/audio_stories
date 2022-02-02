import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileOpenImagePicker extends ProfileEvent {}

class ProfileSaveChanges extends ProfileEvent {
  final File avatar;

  const ProfileSaveChanges({
    required this.avatar,
  });

  @override
  List<Object> get props => [avatar];
}

// class ProfileView extends ProfileEvent {}
//
// class ProfileChangeImageRequest extends ProfileEvent {
//
// }
//
// class ProfileProvideImagePath extends ProfileEvent {}
//
// class ProfileChangeNumber extends ProfileEvent {}
//

