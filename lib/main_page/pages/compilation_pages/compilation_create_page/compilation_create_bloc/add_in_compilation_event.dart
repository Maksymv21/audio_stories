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
  final List listId;
  final File? image;
  final String text;
  final String title;
  final String? id;
  final String? url;

  const ToCreate({
    required this.listId,
    required this.text,
    required this.title,
    this.image,
    this.id,
    this.url,
  });

  @override
  List<Object?> get props => [listId, text, url];
}

class ToCreateCompilation extends AddInCompilationEvent {}
