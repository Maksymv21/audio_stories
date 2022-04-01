import 'package:audio_stories/main_page/widgets/sound_list.dart';
import 'package:audio_stories/main_page/widgets/sound_stream.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/global_repository.dart';
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

class CurrentCompilationPageArguments {
  CurrentCompilationPageArguments({
    required this.title,
    required this.url,
    required this.text,
    required this.listId,
    required this.date,
    required this.id,
  });

  final String title;
  final String url;
  final String text;
  final List listId;
  final Timestamp date;
  final String id;
}

class CurrentCompilationPage extends StatefulWidget {
  static const routName = '/currentCompilation';

  const CurrentCompilationPage({
    Key? key,
    required this.title,
    required this.url,
    required this.text,
    required this.listId,
    required this.date,
    required this.id,
  }) : super(key: key);

  final String title;
  final String url;
  final String text;
  final List listId;
  final Timestamp date;
  final String id;

  @override
  State<CurrentCompilationPage> createState() => _CurrentCompilationPageState();
}

class _CurrentCompilationPageState extends State<CurrentCompilationPage> {
  final GlobalKey<SoundsListState> _key = GlobalKey();
  List<Map<String, dynamic>> sounds = [];

  bool _readMore = false;
  bool _isPlay = false;

  void _createLists(AsyncSnapshot snapshot) {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        for (int j = 0; j < widget.listId.length; j++) {
          if (snapshot.data.docs[i]['id'] == widget.listId[j]) {
            sounds.add({
              'current': false,
              'chek': false,
              'title': snapshot.data.docs[i]['title'],
              'url': snapshot.data.docs[i]['song'],
              'time': snapshot.data.docs[i]['time'],
              'id': widget.listId[j],
            });
          }
        }
      }
    }
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
                        CompilationPage.routName,
                      );
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
          alignment: const AlignmentDirectional(
            0.95,
            -0.95,
          ),
          child: _PopupMenu(
            sounds: sounds,
            id: widget.id,
            text: widget.text,
            url: widget.url,
            date: widget.date,
            title: widget.title,
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
                length: sounds.isEmpty ? widget.listId.length : sounds.length,
                child: Align(
                  alignment: const AlignmentDirectional(0.85, 0.85),
                  child: PlayAllButton(
                    isPlay: _isPlay,
                    play: (i) {
                      for (int i = 0; i < sounds.length; i++) {
                        sounds[i]['current'] = false;
                      }
                      _key.currentState!.playAll(i);
                      _isPlay = true;
                      setState(() {});
                    },
                    stop: () {
                      _key.currentState!.stop();
                      _isPlay = false;
                      setState(() {});
                    },
                  ),
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
                                    widget.text,
                                  ),
                                ],
                              )
                            : Text(
                                widget.text,
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
                  key: _key,
                  sounds: sounds,
                  routName: CurrentCompilationPage.routName,
                  isPopup: true,
                  compilationId: widget.id,
                  play: (i) {
                    if (!_isPlay) {
                      _key.currentState!.play(i);
                    }
                  },
                  stop: () {
                    _key.currentState!.stop();
                    _isPlay = false;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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

  void _edit(BuildContext context) {
    List soundId = [];
    for (int i = 0; i < sounds.length; i++) {
      soundId.add(sounds[i]['id']);
    }
    MainPage.globalKey.currentState!.pushReplacementNamed(
      CreateCompilationPage.routName,
    );
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

  void _pickFew(BuildContext context) {
    List soundId = [];
    for (int i = 0; i < sounds.length; i++) {
      soundId.add(sounds[i]['id']);
    }
    Navigator.pushNamed(
      context,
      PickFewCompilationPage.routName,
      arguments: PickFewCompilationPageArguments(
        title: title,
        url: url,
        sounds: sounds,
        date: date,
        id: id,
        text: text,
      ),
    );
  }

  void _delete(BuildContext context) {
    Database.deleteCompilation({
      'id': id,
      'title': title,
      'date': date,
    });
    MainPage.globalKey.currentState!.pushReplacementNamed(
      CompilationPage.routName,
    );
    context.read<CompilationBloc>().add(
          ToInitialCompilation(),
        );
  }

  void _share() {
    List<String> url = [];
    List<String> title = [];
    for (int i = 0; i < sounds.length; i++) {
      url.add(sounds[i]['url']);
      title.add(sounds[i]['title']);
    }
    GlobalRepo.share(url, title);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) _edit(context);
        if (value == 1) _pickFew(context);
        if (value == 2) _delete(context);
        if (value == 3) _share();
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

// if do PlayAllButton private then everything breaks

//ignore: must_be_immutable
class PlayAllButton extends StatefulWidget {
  PlayAllButton({
    Key? key,
    required this.play,
    required this.stop,
    required this.isPlay,
  }) : super(key: key);

  final void Function(int) play;
  final void Function() stop;
  bool isPlay;

  @override
  State<PlayAllButton> createState() => _PlayAllButtonState();
}

class _PlayAllButtonState extends State<PlayAllButton> {
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
          onPressed: () {
            widget.isPlay ? widget.stop() : widget.play(0);
            setState(() {});
          },
          child: Align(
            widthFactor: 0.6,
            heightFactor: 0.0,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              widget.isPlay ? 'Остановить' : 'Запустить все',
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
              onPressed: () {
                widget.isPlay ? widget.stop() : widget.play;
                setState(() {});
              },
              icon: Image.asset(
                widget.isPlay ? AppIcons.pauseRecord : AppIcons.play,
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
