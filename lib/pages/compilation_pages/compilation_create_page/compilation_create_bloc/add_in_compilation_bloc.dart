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
    on<ToChoiseSound>((event, emit) async {
      emit(
        ChoiseSound(
          image: event.image,
          text: event.text,
          title: event.title,
        ),
      );
    });
    on<ToCreate>((event, emit) async {
      emit(
        Create(
          id: event.id,
          image: event.image,
          text: event.text,
          title: event.title,
        ),
      );
    });
  }
}
