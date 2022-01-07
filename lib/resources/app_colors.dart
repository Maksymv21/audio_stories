import 'dart:core';

import 'package:flutter/material.dart';

class ColorActive {
  Color colorHome = Colors.red;
  Color colorCategory = Colors.grey;
  Color colorAudio = Colors.grey;
  Color colorProfile = Colors.grey;

  // set home(Color color) => colorHome = color;
  // set category(Color color) => colorHome = color;
  // set audio(Color color) => colorHome = color;
  // set profile(Color color) => colorHome = color;

  void homeActive() {
    colorHome = Colors.red;
    colorCategory = Colors.grey;
    colorAudio = Colors.grey;
    colorProfile = Colors.grey;
  }

  void categoryActive() {
    colorHome = Colors.grey;
    colorCategory = Colors.red;
    colorAudio = Colors.grey;
    colorProfile = Colors.grey;
  }

  void audioActive() {
    colorHome = Colors.grey;
    colorCategory = Colors.grey;
    colorAudio = Colors.red;
    colorProfile = Colors.grey;
  }

  void profileActive() {
    colorHome = Colors.grey;
    colorCategory = Colors.grey;
    colorAudio = Colors.grey;
    colorProfile = Colors.red;
  }

}