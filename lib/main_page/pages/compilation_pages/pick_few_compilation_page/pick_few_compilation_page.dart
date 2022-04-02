import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_icons.dart';
import '../../../../utils/database.dart';
import '../../../../widgets/background.dart';
import '../../../main_page.dart';
import '../../../widgets/menu/popup_menu_pick_few.dart';
import '../../../widgets/uncategorized/sound_list_play_all.dart';
import '../compilation_current_page/compilation_current_page.dart';
import '../compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_page/compilation_page.dart';
import '../widgets/image_container.dart';

class PickFewCompilationPageArguments {
  PickFewCompilationPageArguments({
    required this.title,
    required this.url,
    required this.sounds,
    required this.date,
    required this.id,
    required this.text,
  });

  final String title;
  final String url;
  final List<Map<String, dynamic>> sounds;
  final Timestamp date;
  final String id;
  final String text;
}

class PickFewCompilationPage extends StatefulWidget {
  static const routName = '/pickFew';

  const PickFewCompilationPage({
    Key? key,
    required this.title,
    required this.url,
    required this.sounds,
    required this.date,
    required this.id,
    required this.text,
  }) : super(key: key);

  final String title;
  final String url;
  final List<Map<String, dynamic>> sounds;
  final Timestamp date;
  final String id;
  final String text;

  @override
  State<PickFewCompilationPage> createState() => _PickFewCompilationPageState();
}

class _PickFewCompilationPageState extends State<PickFewCompilationPage> {
  void _cancel() {
    for (int i = 0; i < widget.sounds.length; i++) {
      widget.sounds[i]['chek'] = false;
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
                image: AppImages.upGreen,
                height: 325.0,
                child: Align(
                  alignment: const AlignmentDirectional(
                    -1.1,
                    -0.9,
                  ),
                  child: IconButton(
                    onPressed: () {
                      List soundId = [];
                      for (int i = 0; i < widget.sounds.length; i++) {
                        soundId.add(widget.sounds[i]['id']);
                      }
                      Navigator.pushNamed(
                        context,
                        CurrentCompilationPage.routName,
                        arguments: CurrentCompilationPageArguments(
                          title: widget.title,
                          url: widget.url,
                          listId: soundId,
                          date: widget.date,
                          id: widget.id,
                          text: widget.text,
                        ),
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
            sounds: widget.sounds,
            id: widget.id,
            cancel: _cancel,
            set: (i) {
              widget.sounds.removeAt(i);
              setState(() {});
            },
          ),
        ),
        SoundStream(
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
                      widget.title,
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
                url: widget.url,
                date: widget.date,
                length: widget.sounds.length,
              ),
              Expanded(
                flex: 6,
                child: SoundsListPlayAll(
                  sounds: widget.sounds,
                  routName: PickFewCompilationPage.routName,
                  isPopup: false,
                  compilationId: widget.id,
                  repeat: false,
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
  const _PopupMenu({
    Key? key,
    required this.sounds,
    required this.id,
    required this.cancel,
    required this.set,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final String id;
  final void Function() cancel;
  final void Function(int i) set;

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
