import 'package:flutter_bloc/flutter_bloc.dart';

import 'compilation_current_event.dart';
import 'compilation_current_state.dart';

class CompilationCurrentBloc
    extends Bloc<CompilationCurrentEvent, CompilationCurrentState> {
  CompilationCurrentBloc() : super(CurrentCompilationInitial()) {
    on<ToCurrentCompilation>((event, emit) async {
      emit(
        OnCurrentCompilation(
          listId: event.listId,
          url: event.url,
          text: event.text,
          title: event.title,
        ),
      );
    });
  }
}
