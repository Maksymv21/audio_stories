import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddInCompilationState extends Equatable {
  const AddInCompilationState();

  @override
  List<Object?> get props => [];
}

class AddInCompilationInitial extends AddInCompilationState {}

class ImageState extends AddInCompilationState {
  final File image;
  final String text;
  final String title;

  const ImageState({
    required this.image,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [image];
}

class TextState extends AddInCompilationState {
  final String text;
  final String title;

  const TextState({
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [text];
}

class WithImageList extends AddInCompilationState {
  final List<String> id;
  final File image;
  final String text;
  final String title;

  const WithImageList({
    required this.id,
    required this.image,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [id];
}

class WithoutImageList extends AddInCompilationState {
  final List<String> id;
  final String text;
  final String title;

  const WithoutImageList({
    required this.id,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [id];
}
