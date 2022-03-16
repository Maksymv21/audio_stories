import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddInCompilationEvent extends Equatable {
  const AddInCompilationEvent();

  @override
  List<Object?> get props => [];
}

class AddListWithImage extends AddInCompilationEvent{
  final List<String> id;
  final File image;
  final String text;
  final String title;

  const AddListWithImage({
    required this.id,
    required this.image,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [id];
}

class AddListWithoutImage extends AddInCompilationEvent{
  final List<String> id;
  final String text;
  final String title;

  const AddListWithoutImage({
    required this.id,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [id];
}

class AddWithImage extends AddInCompilationEvent {
  final File image;
  final String text;
  final String title;

  const AddWithImage({
    required this.image,
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [text];
}

class AddWithoutImage extends AddInCompilationEvent {
  final String text;
  final String title;

  const AddWithoutImage({
    required this.text,
    required this.title,
  });

  @override
  List<Object?> get props => [text];
}

class InitialCompilation extends AddInCompilationEvent{}
