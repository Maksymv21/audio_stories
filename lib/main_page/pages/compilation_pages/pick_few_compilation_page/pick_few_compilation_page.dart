import 'package:audio_stories/main_page/widgets/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_icons.dart';
import '../../../../utils/database.dart';
import '../../../../widgets/background.dart';
import '../../../main_page.dart';
import '../../../widgets/popup_menu_pick_few.dart';
import '../../../widgets/sound_list.dart';
import '../compilation_current_page/compilation_current_page.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';

class PickFewCompilationPage extends StatefulWidget {
  static const routName = '/pickFew';

  final String? title;
  final String? url;
  final List? listId;
  final Timestamp? date;
  final String? id;

  const PickFewCompilationPage({
    Key? key,
    this.title,
    this.url,
    this.listId,
    this.date,
    this.id,
  }) : super(key: key);

  @override
  State<PickFewCompilationPage> createState() => _PickFewCompilationPageState();
}

class _PickFewCompilationPageState extends State<PickFewCompilationPage> {
  List<Map<String, dynamic>> sounds = [];

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

  void _cancel() {
    for (int i = 0; i < sounds.length; i++) {
      sounds[i]['chek'] = false;
    }
    setState(() {});
  }

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
                  alignment: const AlignmentDirectional(
                    -1.1,
                    -0.9,
                  ),
                  child: IconButton(
                    onPressed: () {
                      MainPage.globalKey.currentState!.pushReplacementNamed(
                        CurrentCompilationPage.routName,
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
          alignment: const AlignmentDirectional(
            0.95,
            -0.95,
          ),
          child: _PopupMenu(
            sounds: sounds,
            id: widget.id!,
            cancel: _cancel,
            set: (i) {
              sounds.removeAt(i);
              setState(() {});
            },
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
              _ImageContainer(
                width: _width,
                height: _height,
                url: widget.url!,
                date: widget.date!,
                length: sounds.isEmpty
                    ? widget.listId!.length
                    : sounds.length,
              ),
              Expanded(
                flex: 6,
                child: SoundsList(
                  sounds: sounds,
                  routName: PickFewCompilationPage.routName,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopupMenu extends StatefulWidget {
  final List<Map<String, dynamic>> sounds;
  final String id;
  final void Function() cancel;
  final void Function(int i) set;

  const _PopupMenu({
    Key? key,
    required this.sounds,
    required this.id,
    required this.cancel,
    required this.set,
  }) : super(key: key);

  @override
  State<_PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<_PopupMenu> {
  int _current = 0;

  void _addInCompilation() {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      List currentId = [];
      for (int i = 0; i < widget.sounds.length; i++) {
        if (widget.sounds[i]['chek']) {
          currentId.add(widget.sounds[i]['id']);
        }
      }
      MainPage.globalKey.currentState!
          .pushReplacementNamed(CompilationPage.routName);
      context.read<CompilationBloc>().add(
            ToAddInCompilation(
              listId: currentId,
            ),
          );
    }
  }

  void _share() {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      List<String> url = [];
      List<String> title = [];
      for (int i = 0; i < widget.sounds.length; i++) {
        if (widget.sounds[i]['chek']) {
          url.add(widget.sounds[i]['url']);
          title.add(widget.sounds[i]['title']);
        }
      }
      GlobalRepo.share(url, title);
    }
  }

  void _download() {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      for (int i = 0; i < widget.sounds.length; i++) {
        if (widget.sounds[i]['chek']) {
          GlobalRepo.download(
            widget.sounds[i]['url'],
            widget.sounds[i]['title'],
          ).then(
            (value) => {
              GlobalRepo.showSnackBar(
                context: context,
                title: 'Файл сохранен.'
                    '\nDownload/${widget.sounds[i]['title']}.aac',
              ),
            },
          );
        }
      }
    }
  }

  void _delete() {
    if (!_chek(
      current: _current,
    )) {
      _choiseSnackBar(context);
    } else {
      if (_current == widget.sounds.length) {
        GlobalRepo.showSnackBar(
          context: context,
          title: 'В подборке должно оставаться минимум одно аудио',
        );
      } else {
        for (int i = widget.sounds.length - 1; i >= 0; i = i - 1) {
          if (widget.sounds[i]['chek']) {
            Database.deleteSoundInCompilation(
              {
                'sounds': FieldValue.arrayRemove(
                  [widget.sounds[i]['id']],
                ),
              },
              widget.id,
              widget.sounds[i]['id'],
            );
            widget.set(i);
          }
        }
      }
    }
  }

  bool _chek({int? current}) {
    _current = 0;
    bool chek = false;
    for (var map in widget.sounds) {
      if (map.containsKey('chek')) {
        if (map['chek']) {
          chek = true;
          if (current != null) _current++;
        }
      }
    }
    return chek;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuPickFew(
      onSelected: (value) async {
        if (value == 0) widget.cancel();
        if (value == 1) _addInCompilation();
        if (value == 2) _share();
        if (value == 3) _download();
        if (value == 4) _delete();
      },
    );
  }

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
  }
}

class _ImageContainer extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final Timestamp date;
  final int length;

  const _ImageContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.url,
    required this.date,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: Image.network(url).image,
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.9,
            height: height * 0.3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xff454545),
                ],
                stops: [0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(
                    -0.85,
                    -0.9,
                  ),
                  child: Text(
                    _convertDate(date),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(
                    -0.85,
                    0.9,
                  ),
                  child: Text(
                    '$length аудио'
                    '\n0 часов',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _convertDate(Timestamp date) {
    final String dateTime = date.toDate().toString();
    final String result = dateTime.substring(8, 10) +
        '.' +
        dateTime.substring(5, 7) +
        '.' +
        dateTime.substring(2, 4);
    return result;
  }
}

// //ignore: must_be_immutable
// class _SoundsList extends StatefulWidget {
//   final List<Map<String, dynamic>> sounds;
//   void Function() onTap;
//
//   _SoundsList({
//     Key? key,
//     required this.sounds,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   State<_SoundsList> createState() => _SoundsListState();
// }
//
// class _SoundsListState extends State<_SoundsList> {
//   Widget _player = const Text('');
//   double _bottom = 10.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(bottom: _bottom),
//           child: ListView.builder(
//               itemCount: widget.sounds.length,
//               itemBuilder: (context, index) {
//                 Color color = widget.sounds[index]['current']
//                     ? const Color(0xffF1B488)
//                     : AppColor.active;
//
//                 return Column(
//                   children: [
//                     SoundContainer(
//                       color: color,
//                       title: widget.sounds[index]['title'],
//                       time: (widget.sounds[index]['time'] / 60)
//                           .toStringAsFixed(1),
//                       buttonRight: Align(
//                         alignment: const AlignmentDirectional(0.9, -1.0),
//                         child: CustomCheckBox(
//                           color: Colors.black87,
//                           value: widget.sounds[index]['chek'],
//                           onTap: () {
//                             setState(() {
//                               widget.sounds[index]['chek'] =
//                                   !widget.sounds[index]['chek'];
//                             });
//                             widget.onTap();
//                           },
//                         ),
//                       ),
//                       onTap: () {
//                         if (!widget.sounds[index]['current']) {
//                           for (int i = 0; i < widget.sounds.length; i++) {
//                             widget.sounds[i]['current'] = false;
//                           }
//                           setState(() {
//                             _player = const Text('');
//                             _bottom = 90.0;
//                           });
//
//                           Future.delayed(const Duration(milliseconds: 50), () {
//                             setState(() {
//                               widget.sounds[index]['current'] = true;
//                               _player = CustomPlayer(
//                                 onDismissed: (direction) {
//                                   setState(() {
//                                     _player = const Text('');
//                                     _bottom = 10.0;
//                                     widget.sounds[index]['current'] = false;
//                                   });
//                                 },
//                                 title: widget.sounds[index]['title'],
//                                 url: widget.sounds[index]['url'],
//                                 id: widget.sounds[index]['id'],
//                                 routName: PickFewCompilationPage.routName,
//                               );
//                             });
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(
//                       height: 7.0,
//                     ),
//                   ],
//                 );
//               }),
//         ),
//         Align(
//           alignment: AlignmentDirectional.bottomCenter,
//           child: _player,
//         ),
//       ],
//     );
//   }
// }
