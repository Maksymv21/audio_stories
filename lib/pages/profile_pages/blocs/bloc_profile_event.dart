import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileOpenImagePicker extends ProfileEvent {}

class ProfileSaveChanges extends ProfileEvent {
  final String? name;
  final File? avatar;

  const ProfileSaveChanges({
    this.avatar,
    this.name,
  });

  @override
  List<Object?> get props => [avatar];
}



