import 'package:equatable/equatable.dart';

abstract class CompilationState extends Equatable {
  const CompilationState();

  @override
  List<Object?> get props => [];
}

class InitialCompilation extends CompilationState {}

class AddInCompilation extends CompilationState {
  final List listId;

  const AddInCompilation({
    required this.listId,
  });

  @override
  List<Object?> get props => [listId];
}
