import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddInCompilationEvent extends Equatable {
  const AddInCompilationEvent();

  @override
  List<Object?> get props => [];
}

class ToChoiseSound extends AddInCompilationEvent {
  final File? image;
  final String text;
  final String title;

  const ToChoiseSound({
    required this.text,
    required this.title,
    this.image,
  });

  @override
  List<Object?> get props => [text];
}

class ToCreate extends AddInCompilationEvent {
  final List<String> id;
  final File? image;
  final String text;
  final String title;

  const ToCreate({
    required this.id,
    required this.text,
    required this.title,
    this.image,
  });

  @override
  List<Object?> get props => [id];
}

class InitialCompilation extends AddInCompilationEvent {}
