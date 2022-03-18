import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class CompilationCurrentState extends Equatable {
  const CompilationCurrentState();

  @override
  List<Object?> get props => [];
}

class CurrentCompilationInitial extends CompilationCurrentState{}

class OnCurrentCompilation extends CompilationCurrentState {
  final List listId;
  final String text;
  final String title;
  final String url;
  final Timestamp date;

  const OnCurrentCompilation({
    required this.listId,
    required this.url,
    required this.text,
    required this.title,
    required this.date,
  });

  @override
  List<Object?> get props => [listId];
}

