import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ColorEvent {}

class ColorHome extends ColorEvent {}

class ColorCategory extends ColorEvent {}

class ColorAudio extends ColorEvent {}

class ColorProfile extends ColorEvent {}

class ColorBloc extends Bloc<ColorEvent, List<Color>> {
  ColorBloc(List<Color> initialState) : super(initialState) {
    on<ColorHome>(
      (event, emit) async {
        emit(
          [Colors.red, Colors.grey, Colors.grey, Colors.grey],
        );
      },
    );
    on<ColorCategory>(
      (event, emit) async {
        emit(
          [Colors.grey, Colors.red, Colors.grey, Colors.grey],
        );
      },
    );
    on<ColorAudio>(
      (event, emit) async {
        emit(
          [Colors.grey, Colors.grey, Colors.red, Colors.grey],
        );
      },
    );
    on<ColorProfile>(
      (event, emit) async {
        emit(
          [Colors.grey, Colors.grey, Colors.grey, Colors.red],
        );
      },
    );
  }
}
