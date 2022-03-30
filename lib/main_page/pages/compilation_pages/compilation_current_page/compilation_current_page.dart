import 'package:audio_stories/main_page/widgets/sound_list.dart';
import 'package:audio_stories/main_page/widgets/sound_stream.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_icons.dart';
import '../../../../widgets/background.dart';
import '../../../main_page.dart';
import '../compilation_create_page/compilation_create_bloc/add_in_compilation_bloc.dart';
import '../compilation_create_page/compilation_create_bloc/add_in_compilation_event.dart';
import '../compilation_create_page/create_compilation_page.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';
import '../pick_few_compilation_page/pick_few_compilation_page.dart';
import '../widgets/image_container.dart';

class CurrentCompilationPage extends StatefulWidget {
  static const routName = '/currentCompilation';

  final String? title;
  final String? url;
  final String? text;
  final List? listId;
  final Timestamp? date;
  final String? id;

  const CurrentCompilationPage({
    Key? key,
    this.title,
    this.url,
    this.text,
    this.listId,
    this.date,
    this.id,
  }) : super(key: key);

  @override
  State<CurrentCompilationPage> createState() => _CurrentCompilationPageState();
}

class _CurrentCompilationPageState extends State<CurrentCompilationPage> {
  List<Map<String, dynamic>> sounds = [];

  bool _readMore = false;

  void _createLists(AsyncSnapshot snapshot) {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        for (int j = 0; j < widget.listId!.length; j++) {
          if (snapshot.data.docs[i]['id'] == widget.listId![j]) {
            sounds.add({
              'current': false,
              'chek': false,
              'title': snapshot.data.docs[i]['title'],
              'url': snapshot.data.docs[i]['song'],
              'time': snapshot.data.docs[i]['time'],
              'id': widget.listId![j],
            });
          }
        }
      }
    }
  }

  // void _play() {
  //   if (current.isEmpty) {
  //     GlobalRepo.showSnackBar(
  //       context: context,
  //       title: 'Отсутствуют аудио для проигрования',
  //     );
  //   } else {
  //     List soundId = [];
  //     for(int i = 0; i < widget.listId!.length; i++) {
  //       soundId.add(sounds[i]['id']);
  //     }
  //     if (!current.contains(true)) {
  //       setState(() {
  //         _playAll = !_playAll;
  //         _player = _next(
  //           index: 0,
  //           listUrl: listUrl,
  //           listTitle: listTitle,
  //           listId: soundId,
  //         );
  //       });
  //     } else {
  //       setState(() {
  //         _playAll = !_playAll;
  //         _player = const Text('');
  //         _bottom = 10.0;
  //         for (int i = 0; i < current.length; i++) {
  //           current[i] = false;
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Background(
                image: AppIcons.upGreen,
                height: 325.0,
                child: Align(
                  alignment: const AlignmentDirectional(-1.1, -0.9),
                  child: IconButton(
                    onPressed: () {
                      MainPage.globalKey.currentState!
                          .pushReplacementNamed(CompilationPage.routName);
                      context.read<CompilationBloc>().add(
                            ToInitialCompilation(),
                          );
                    },
                    icon: Image.asset(AppIcons.back),
                    iconSize: 60.0,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(0.95, -0.95),
          child: _PopupMenu(
            sounds: sounds,
            id: widget.id!,
            text: widget.text!,
            url: widget.url!,
            date: widget.date!,
            title: widget.title!,
          ),
        ),
        SoundStream(
          create: _createLists,
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: _width * 0.05,
                  bottom: _height * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              ImageContainer(
                width: _width,
                height: _height,
                url: widget.url!,
                date: widget.date!,
                length: sounds.isEmpty ? widget.listId!.length : sounds.length,
                child: const Align(
                  alignment: AlignmentDirectional(0.85, 0.85),
                  child: PlayAllButton(),
                ),
              ),
              Expanded(
                flex: _readMore ? 3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: _width * 0.07,
                    right: _width * 0.07,
                    bottom: 0.0,
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: _readMore
                            ? ListView(
                                padding: const EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 10.0,
                                ),
                                children: [
                                  Text(
                                    widget.text!,
                                  ),
                                ],
                              )
                            : Text(
                                widget.text!,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              _readMore
                  ? const SizedBox()
                  : Expanded(
                      child: TextButton(
                        child: const Text(
                          'Подробнее',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _readMore = true;
                          });
                        },
                      ),
                    ),
              Expanded(
                flex: _readMore ? 3 : 4,
                child: SoundsList(
                    sounds: sounds,
                    routName: CurrentCompilationPage.routName,
                    isPopup: true,
                    compilationId: widget.id!),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Widget _next({
//   required int index,
//   required List<String> listTitle,
//   required List<String> listUrl,
//   required List listId,
// }) {
//   final String title = listTitle[index];
//   final String url = listUrl[index];
//   final String id = listId[index];
//   setState(() {
//     current[index] = true;
//   });
//
//   return Dismissible(
//     key: const Key(''),
//     direction: DismissDirection.down,
//     onDismissed: (direction) {
//       setState(() {
//         _player = const Text('');
//         _bottom = 10.0;
//         current[index] = false;
//       });
//     },
//     child: PlayerContainer(
//       title: title,
//       url: url,
//       id: id,
//       onPressed: () =>
//           GlobalRepo.toPlayPage(
//             context: context,
//             url: url,
//             title: title,
//             id: id,
//             routName: CurrentCompilationPage.routName,
//           ),
//       whenComplete: () {
//         if (index + 1 < listId.length) {
//           setState(() {
//             _player = const Text('');
//             current[index] = false;
//           });
//           Future.delayed(const Duration(milliseconds: 50), () {
//             setState(() {
//               _player = _next(
//                 index: index + 1,
//                 listId: listId,
//                 listTitle: listTitle,
//                 listUrl: listUrl,
//               );
//             });
//           });
//         }
//       },
//     ),
//   );
// }

}

class _PopupMenu extends StatelessWidget {
  final List<Map<String, dynamic>> sounds;
  final String title;
  final String url;
  final Timestamp date;
  final String text;
  final String id;

  const _PopupMenu({
    Key? key,
    required this.sounds,
    required this.id,
    required this.text,
    required this.url,
    required this.date,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) async {
        if (value == 0) {
          List soundId = [];
          for (int i = 0; i < sounds.length; i++) {
            soundId.add(sounds[i]['id']);
          }
          MainPage.globalKey.currentState!
              .pushReplacementNamed(CreateCompilationPage.routName);
          context.read<AddInCompilationBloc>().add(
                ToCreate(
                  listId: soundId,
                  text: text,
                  title: title,
                  url: url,
                  id: id,
                ),
              );
        }
        if (value == 1) {
          List soundId = [];
          for (int i = 0; i < sounds.length; i++) {
            soundId.add(sounds[i]['id']);
          }
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => PickFewCompilationPage(
                title: title,
                url: url,
                listId: soundId,
                date: date,
                id: id,
              ),
            ),
          );
        }
        if (value == 2) {
          Database.deleteCompilation({
            'id': id,
            'title': title,
            'date': date,
          });
          MainPage.globalKey.currentState!
              .pushReplacementNamed(CompilationPage.routName);
          context.read<CompilationBloc>().add(
                ToInitialCompilation(),
              );
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Редактировать',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Выбрать несколько',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Удалить подборку',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            'Поделиться',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}

class PlayAllButton extends StatefulWidget {
  const PlayAllButton({Key? key}) : super(key: key);

  @override
  State<PlayAllButton> createState() => _PlayAllButtonState();
}

class _PlayAllButtonState extends State<PlayAllButton> {
  bool _playAll = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.7),
            minimumSize: const Size(168.0, 46.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onPressed: () => _playAll = !_playAll,
          child: Align(
            widthFactor: 0.6,
            heightFactor: 0.0,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _playAll ? 'Остановить' : 'Запустить все',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'TTNormsL',
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        Transform.scale(
          scale: 1.3,
          child: ColorFiltered(
            child: IconButton(
              onPressed: () => _playAll = !_playAll,
              icon: Image.asset(
                _playAll ? AppIcons.pauseRecord : AppIcons.play,
              ),
            ),
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcATop,
            ),
          ),
        ),
      ],
    );
  }
}
