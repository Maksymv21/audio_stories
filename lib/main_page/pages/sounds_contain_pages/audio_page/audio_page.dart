import 'dart:async';

import 'package:audio_stories/main_page/widgets/menu/pick_few_popup.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_stream.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';

import '../../../widgets/buttons/button_menu.dart';
import '../../../widgets/menu/popup_menu_pick_few.dart';
import '../../../widgets/uncategorized/sound_list_play_all.dart';

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
  double _hours = 0;

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
        _hours = (_hours + snapshot.data.docs[i]['time']) / 3600;
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
              ? PopupMenuPickFew(
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
                      '\n${_hours.toStringAsFixed(0)} ${_hoursFormat(_hours)}',
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
                      if (sounds.isNotEmpty) {
                        for (int i = 0; i < sounds.length; i++) {
                          sounds[i]['current'] = false;
                        }
                        _key.currentState!.playAll(i);
                        _isPlay = true;
                        setState(() {});
                      }
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
                Future.delayed(
                    const Duration(
                      milliseconds: 1500,
                    ), () {
                  setState(() {
                    sounds = [];
                  });
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  String _hoursFormat(double hours) {
    if (hours > 1 && hours < 5) {
      return 'часа';
    }
    if (hours == 1) {
      return 'час';
    } else {
      return 'часов';
    }
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
