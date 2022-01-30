// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// abstract class ColorEvent extends Equatable {
//   const ColorEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class ColorHome extends ColorEvent {}
//
// class ColorCategory extends ColorEvent {}
//
// class ColorRecord extends ColorEvent {}
//
// class ColorAudio extends ColorEvent {}
//
// class ColorProfile extends ColorEvent {}
//
// class NoColor extends ColorEvent {}
//
// abstract class ColorState extends Equatable {
//   const ColorState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class CurrentIndexChanged extends ColorState {
//   final int currentIndex;
//
//   const CurrentIndexChanged({required this.currentIndex});
//
//   @override
//   List<Object> get props => [currentIndex];
// }
//
// class ColorBloc extends Bloc<ColorEvent, ColorState> {
//   ColorBloc(ColorState initialState)
//       : super(
//           const CurrentIndexChanged(
//             currentIndex: 0,
//           ),
//         ) {
//     on<ColorHome>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 0,
//         ),
//       );
//     });
//     on<ColorCategory>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 1,
//         ),
//       );
//     });
//     on<ColorRecord>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 2,
//         ),
//       );
//     });
//     on<ColorAudio>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 3,
//         ),
//       );
//     });
//     on<ColorProfile>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 4,
//         ),
//       );
//     });
//     on<NoColor>((event, emit) {
//       emit(
//         const CurrentIndexChanged(
//           currentIndex: 5,
//         ),
//       );
//     });
//   }
// }

// class ColorBloc extends Bloc<ColorEvent, int index> {
//   ColorBloc(int index) : super(index == 0) {
//     on<ColorHome>(
//       (event, emit) async {
//         emit(
//           index = 0;
//         );
//       },
//     );
//     on<ColorCategory>(
//       (event, emit) async {
//         emit(
//           [
//             AppColor.disActive,
//             AppColor.active,
//             AppColor.disActive,
//             AppColor.disActive,
//           ],
//         );
//       },
//     );
//     on<ColorAudio>(
//       (event, emit) async {
//         emit(
//           [
//             AppColor.disActive,
//             AppColor.disActive,
//             AppColor.active,
//             AppColor.disActive,
//           ],
//         );
//       },
//     );
//     on<ColorProfile>(
//       (event, emit) async {
//         emit(
//           [
//             AppColor.disActive,
//             AppColor.disActive,
//             AppColor.disActive,
//             AppColor.active,
//           ],
//         );
//       },
//     );
//     on<NoColor>(
//       (event, emit) async {
//         emit(
//           [
//             AppColor.disActive,
//             AppColor.disActive,
//             AppColor.disActive,
//             AppColor.disActive,
//           ],
//         );
//       },
//     );
//   }
//}
