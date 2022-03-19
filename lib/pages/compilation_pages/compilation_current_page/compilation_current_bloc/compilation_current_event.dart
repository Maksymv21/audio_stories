import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class CompilationCurrentEvent extends Equatable {
  const CompilationCurrentEvent();

  @override
  List<Object?> get props => [];
}

class ToCurrentCompilation extends CompilationCurrentEvent{
  final List listId;
  final String text;
  final String title;
  final String url;
  final Timestamp date;
  final String id;

  const ToCurrentCompilation({
    required this.listId,
    required this.url,
    required this.text,
    required this.title,
    required this.date,
    required this.id,
  });

  @override
  List<Object?> get props => [listId];
}