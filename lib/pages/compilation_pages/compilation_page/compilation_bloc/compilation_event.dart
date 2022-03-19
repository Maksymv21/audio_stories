import 'package:equatable/equatable.dart';

abstract class CompilationEvent extends Equatable {
  const CompilationEvent();

  @override
  List<Object?> get props => [];
}

class ToInitialCompilation extends CompilationEvent {}

class ToAddInCompilation extends CompilationEvent {
  final String id;

  const ToAddInCompilation({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
