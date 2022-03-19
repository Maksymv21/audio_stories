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
  final List<String> id;
  final File? image;
  final String text;
  final String title;

  const Create({
    required this.id,
    required this.text,
    required this.title,
    this.image,
  });

  @override
  List<Object?> get props => [id];
}

