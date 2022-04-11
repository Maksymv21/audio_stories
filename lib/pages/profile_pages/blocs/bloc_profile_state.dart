import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable{
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileChangeAvatar extends ProfileState {
  final File avatar;

  const ProfileChangeAvatar({
    required this.avatar,
  });

  @override
  List<Object> get props => [avatar];
}
