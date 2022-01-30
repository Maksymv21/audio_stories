import 'package:equatable/equatable.dart';

abstract class IndexEvent extends Equatable {
  const IndexEvent();

  @override
  List<Object?> get props => [];
}

class ColorHome extends IndexEvent {}

class ColorCategory extends IndexEvent {}

class ColorRecord extends IndexEvent {}

class ColorAudio extends IndexEvent {}

class ColorProfile extends IndexEvent {}

class NoColor extends IndexEvent {}