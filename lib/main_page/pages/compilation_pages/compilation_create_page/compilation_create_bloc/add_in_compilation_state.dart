import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddInCompilationState extends Equatable {
  const AddInCompilationState();

  @override
  List<Object?> get props => [];
}

class AddInCompilationInitial extends AddInCompilationState {}

class ChoiseSound extends AddInCompilationState {
  final File? image;
  final String text;
  final String title;

  const ChoiseSound({
    required this.text,
    required this.title,
    this.image,
  });

  @override
  List<Object?> get props => [text];
}

class Create extends AddInCompilationState {
  final List listId;
  final File? image;
  final String text;
  final String title;
  final String? id;
  final String? url;

  const Create({
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
