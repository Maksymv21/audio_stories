import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_index_event.dart';

class BlocIndex extends Bloc<IndexEvent, int> {
  BlocIndex(int currentIndex) : super(currentIndex = 0) {
    on<ColorHome>((event, emit) {
      emit(
        currentIndex = 0,
      );
    });
    on<ColorCategory>((event, emit) {
      emit(
        currentIndex = 1,
      );
    });
    on<ColorRecord>((event, emit) {
      emit(
        currentIndex = 2,
      );
    });
    on<ColorAudio>((event, emit) {
      emit(
        currentIndex = 3,
      );
    });
    on<ColorProfile>((event, emit) {
      emit(
        currentIndex = 4,
      );
    });
    on<NoColor>((event, emit) {
      emit(
        currentIndex = 5,
      );
    });
    on<ColorPlay>((event, emit) {
      emit(
        currentIndex = 6,
      );
    });
  }
}
