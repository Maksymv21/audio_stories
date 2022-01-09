import 'package:audio_stories/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ColorEvent {}

class ColorHome extends ColorEvent {}

class ColorCategory extends ColorEvent {}

class ColorAudio extends ColorEvent {}

class ColorProfile extends ColorEvent {}

class NoColor extends ColorEvent {}

class ColorBloc extends Bloc<ColorEvent, List<Color>> {
  ColorBloc(List<Color> initialState) : super(initialState) {
    on<ColorHome>(
      (event, emit) async {
        emit(
          [
            AppColor.active,
            AppColor.disActive,
            AppColor.disActive,
            AppColor.disActive,
          ],
        );
      },
    );
    on<ColorCategory>(
      (event, emit) async {
        emit(
          [
            AppColor.disActive,
            AppColor.active,
            AppColor.disActive,
            AppColor.disActive,
          ],
        );
      },
    );
    on<ColorAudio>(
      (event, emit) async {
        emit(
          [
            AppColor.disActive,
            AppColor.disActive,
            AppColor.active,
            AppColor.disActive,
          ],
        );
      },
    );
    on<ColorProfile>(
      (event, emit) async {
        emit(
          [
            AppColor.disActive,
            AppColor.disActive,
            AppColor.disActive,
            AppColor.active,
          ],
        );
      },
    );
    on<NoColor>(
      (event, emit) async {
        emit(
          [
            AppColor.disActive,
            AppColor.disActive,
            AppColor.disActive,
            AppColor.disActive,
          ],
        );
      },
    );
  }
}
