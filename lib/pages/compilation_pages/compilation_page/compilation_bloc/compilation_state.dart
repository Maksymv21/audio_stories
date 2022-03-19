import 'package:equatable/equatable.dart';

abstract class CompilationState extends Equatable {
  const CompilationState();

  @override
  List<Object?> get props => [];
}

class InitialCompilation extends CompilationState {}

class AddInCompilation extends CompilationState {
  final String id;

  const AddInCompilation({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
