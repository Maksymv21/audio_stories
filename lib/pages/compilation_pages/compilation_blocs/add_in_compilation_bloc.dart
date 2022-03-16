import 'package:audio_stories/pages/compilation_pages/compilation_blocs/add_in_compilation_event.dart';
import 'package:audio_stories/pages/compilation_pages/compilation_blocs/add_in_compilation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddInCompilationBloc
    extends Bloc<AddInCompilationEvent, AddInCompilationState> {
  AddInCompilationBloc() : super(AddInCompilationInitial()) {
    on<InitialCompilation>((event, emit) async {
      emit(
        AddInCompilationInitial(),
      );
    });
    on<AddWithImage>((event, emit) async {
      emit(
        ImageState(
          image: event.image,
          text: event.text,
          title: event.title,
        ),
      );
    });
    on<AddWithoutImage>((event, emit) async {
      emit(
        TextState(
          text: event.text,
          title: event.title,
        ),
      );
    });
    on<AddListWithImage>((event, emit) async {
      emit(
        WithImageList(
          id: event.id,
          image: event.image,
          text: event.text,
          title: event.title,
        ),
      );
    });
    on<AddListWithoutImage>((event, emit) async {
      emit(
        WithoutImageList(
          id: event.id,
          text: event.text,
          title: event.title,
        ),
      );
    });
  }
}
