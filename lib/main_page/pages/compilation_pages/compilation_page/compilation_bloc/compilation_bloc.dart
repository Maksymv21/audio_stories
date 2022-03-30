import 'package:flutter_bloc/flutter_bloc.dart';

import 'compilation_event.dart';
import 'compilation_state.dart';

class CompilationBloc extends Bloc<CompilationEvent, CompilationState> {
  CompilationBloc() : super(InitialCompilation()) {
    on<ToInitialCompilation>((event, emit) async {
      emit(
        InitialCompilation(),
      );
    });
    on<ToAddInCompilation>((event, emit) async {
      emit(
        AddInCompilation(
          listId: event.listId,
        ),
      );
    });
  }
}
