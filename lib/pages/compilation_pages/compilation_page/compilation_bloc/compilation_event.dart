import 'package:equatable/equatable.dart';

abstract class CompilationEvent extends Equatable {
  const CompilationEvent();

  @override
  List<Object?> get props => [];
}

class ToInitialCompilation extends CompilationEvent {}

class ToAddInCompilation extends CompilationEvent {
  final List listId;

  const ToAddInCompilation({
    required this.listId,
  });

  @override
  List<Object?> get props => [listId];
}
