import 'dart:async';

import 'package:audio_stories/main_page/widgets/menu/pick_few_popup.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../utils/database.dart';
import '../../../main_page.dart';
import '../../../widgets/buttons/button_menu.dart';
import '../../../widgets/menu/popup_menu_pick_few.dart';
import '../../../widgets/uncategorized/sound_list_play_all.dart';
import '../../compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../compilation_pages/compilation_page/compilation_page.dart';

class AudioPage extends StatefulWidget {
  static const routName = '/audio';

  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final GlobalKey<SoundsListPlayAllState> _key = GlobalKey();
  List<Map<String, dynamic>> sounds = [];
  bool _repeat = false;
  bool _pickFew = false;
  bool _isPlay = false;

  Future<void> _createList(AsyncSnapshot snapshot) async {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        sounds.add(
          {
            'chek': false,
            'current': false,
            'title': snapshot.data.docs[i]['title'],
            'time': snapshot.data.docs[i]['time'],
            'id': snapshot.data.docs[i]['id'],
            'url': snapshot.data.docs[i]['song'],
          },
        );
      }
      Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              flex: 3,
              child: Background(
                image: AppImages.upBlue,
                height: 275.0,
                child: Align(
                  alignment: AlignmentDirectional(
                    -1.1,
                    -0.9,
                  ),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(
              flex: 5,
            ),
          ],
        ),
        const Align(
          alignment: AlignmentDirectional(
            0.0,
            -0.91,
          ),
          child: Text(
            'Аудиозаписи',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 36.0,
              letterSpacing: 3.0,
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0.95, -0.96),
          child: _pickFew
              ? _PopupMenuPickFew(
                  sounds: sounds,
                  cancel: () {
                    setState(() {
                      _pickFew = false;
                    });
                  },
                  set: () {
                    Future.delayed(
                        const Duration(
                          milliseconds: 1000,
                        ), () {
                      setState(() {
                        sounds = [];
                      });
                    });
                  },
                )
              : PickFewPopup(
                  pickFew: () {
                    _pickFew = true;
                    setState(() {});
                  },
                ),
        ),
        const Align(
          alignment: AlignmentDirectional(0.00, -0.78),
          child: Text(
            'Все в одном месте',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: _width * 0.035,
                  ),
                  SizedBox(
                    width: _width * 0.16,
                    child: Text(
                      '${sounds.length} аудио'
                      '\n0 часов',
                      style: const TextStyle(
                        fontFamily: 'TTNormsL',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.23,
                  ),
                  _PlayAllButton(
                    width: _width,
                    repeat: _repeat,
                    isPlay: _isPlay,
                    tapRepeat: () {
                      setState(() {
                        _repeat = !_repeat;
                      });
                    },
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
                ],
              ),
            ),
            const Spacer(
              flex: 8,
            ),
          ],
        ),
        SoundStream(
          create: _createList,
          child: Padding(
            padding: EdgeInsets.only(top: _height * 0.31),
            child: SoundsListPlayAll(
              key: _key,
              sounds: sounds,
              routName: AudioPage.routName,
              isPopup: !_pickFew,
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
              repeat: _repeat,
              onDelete: () {
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PopupMenuPickFew extends StatefulWidget {
  const _PopupMenuPickFew({
    Key? key,
    required this.sounds,
    required this.cancel,
    required this.set,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function() cancel;
  final void Function() set;

  @override
  State<_PopupMenuPickFew> createState() => _PopupMenuPickFewState();
}

class _PopupMenuPickFewState extends State<_PopupMenuPickFew> {
  void _addInCompilation(BuildContext context) {
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
      context.read<BlocIndex>().add(ColorCategory());
    }
  }

  void _share(BuildContext context) {
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

  void _download(BuildContext context) {
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

  void _delete(BuildContext context) {
    if (!_chek()) {
      _choiseSnackBar(context);
    } else {
      for (int i = widget.sounds.length - 1; i >= 0; i = i - 1) {
        if (widget.sounds[i]['chek']) {
          Database.createOrUpdateSound(
            {
              'deleted': true,
              'dateDeleted': Timestamp.now(),
              'id': widget.sounds[i]['id'],
            },
          );
        }
      }
      widget.set();
    }
  }

  bool _chek() {
    bool chek = false;
    for (var map in widget.sounds) {
      if (map.containsKey('chek')) {
        if (map['chek']) {
          chek = true;
        }
      }
    }
    return chek;
  }

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuPickFew(
      onSelected: (value) async {
        if (value == 0) widget.cancel();
        if (value == 1) _addInCompilation(context);
        if (value == 2) _share(context);
        if (value == 3) _download(context);
        if (value == 4) _delete(context);
      },
    );
  }
}

class _PlayAllButton extends StatefulWidget {
  const _PlayAllButton({
    Key? key,
    required this.width,
    required this.repeat,
    required this.isPlay,
    required this.tapRepeat,
    required this.play,
    required this.stop,
  }) : super(key: key);

  final double width;
  final bool repeat;
  final bool isPlay;
  final void Function() tapRepeat;
  final void Function(int) play;
  final void Function() stop;

  @override
  State<_PlayAllButton> createState() => _PlayAllButtonState();
}

class _PlayAllButtonState extends State<_PlayAllButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: widget.width * 0.29,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: widget.repeat
                    ? AppColor.greyActive
                    : AppColor.greyDisActive,
                minimumSize: const Size(100.0, 46.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onPressed: () => widget.tapRepeat(),
              child: Container(
                margin: const EdgeInsets.only(
                  left: 45.0,
                ),
                child: Image(
                  alignment: AlignmentDirectional.bottomEnd,
                  image: Image.asset(AppIcons.repeat).image,
                ),
              ),
            ),
          ],
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
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
                color: AppColor.active,
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
                widget.isPlay ? widget.stop() : widget.play(0);
                setState(() {});
              },
              icon: Image.asset(
                widget.isPlay ? AppIcons.pauseRecord : AppIcons.play,
              ),
            ),
            colorFilter: const ColorFilter.mode(
              AppColor.active,
              BlendMode.srcATop,
            ),
          ),
        ),
      ],
    );
  }
}
