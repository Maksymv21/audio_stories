import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_in_compilation_event.dart';
import 'add_in_compilation_state.dart';

class AddInCompilationBloc
    extends Bloc<AddInCompilationEvent, AddInCompilationState> {
  AddInCompilationBloc() : super(AddInCompilationInitial()) {
    on<ToCreateCompilation>((event, emit) async {
      emit(
        AddInCompilationInitial(),
      );
    });
    on<ToChoiseSound>((event, emit) {
      emit(
        ChoiseSound(
          image: event.image,
          text: event.text,
          title: event.title,
        ),
      );
    });
    on<ToCreate>((event, emit) {
      emit(
        Create(
          listId: event.listId,
          image: event.image,
          text: event.text,
          title: event.title,
          id: event.id,
          url: event.url,
        ),
      );
    });
  }
}
