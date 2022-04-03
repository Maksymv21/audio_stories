import 'package:audio_stories/main_page/widgets/menu/popup_menu_sound_container.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../repositories/global_repository.dart';
import '../../../resources/app_color.dart';
import '../../../utils/database.dart';
import 'custom_checkbox.dart';
import 'custom_player.dart';

//ignore: must_be_immutable
class SoundsListPlayAll extends StatefulWidget {
  const SoundsListPlayAll({
    Key? key,
    required this.sounds,
    required this.routName,
    required this.isPopup,
    required this.repeat,
    required this.onDelete,
    this.compilationId,
    this.play,
    this.stop,
    this.page,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function(int)? play;
  final void Function()? stop;
  final void Function() onDelete;
  final String routName;
  final bool isPopup;
  final bool repeat;
  final String? compilationId;
  final String? page;

  @override
  State<SoundsListPlayAll> createState() => SoundsListPlayAllState();
}

class SoundsListPlayAllState extends State<SoundsListPlayAll> {
  Widget? _player;
  double _bottom = 10.0;
  bool isPlay = false;

  void _onDeleteInCompilation(
    BuildContext context,
    int index,
  ) {
    if (widget.sounds.length == 1) {
      GlobalRepo.showSnackBar(
        context: context,
        title: 'В подборке должно оставаться '
            'минимум одно аудио',
      );
    } else {
      Database.deleteSoundInCompilation(
        {
          'sounds': FieldValue.arrayRemove(
            [widget.sounds[index]['id']],
          ),
        },
        widget.compilationId!,
        widget.sounds[index]['id'],
      );
      widget.sounds.removeAt(index);
    }
  }

  void _onDeleteInAudio(int index) {
    _player = null;
    widget.sounds.removeAt(index);
  }

  void play(int index) {
    if (!widget.sounds[index]['current']) {
      for (int i = 0; i < widget.sounds.length; i++) {
        widget.sounds[i]['current'] = false;
      }
      setState(() {
        _player = null;
        _bottom = 90.0;
      });

      Future.delayed(
        const Duration(milliseconds: 10),
        () {
          setState(
            () {
              widget.sounds[index]['current'] = true;
              isPlay = true;
              _player = CustomPlayer(
                onDismissed: (direction) {
                  widget.stop == null ? stop() : widget.stop!();
                },
                title: widget.sounds[index]['title'],
                url: widget.sounds[index]['url'],
                id: widget.sounds[index]['id'],
                routName: widget.routName,
              );
            },
          );
        },
      );
    }
  }

  void stop() {
    setState(
      () {
        _player = null;
        _bottom = 10.0;
        for (int i = 0; i < widget.sounds.length; i++) {
          widget.sounds[i]['current'] = false;
        }
      },
    );
  }

  void playAll(
    int index,
  ) {
    setState(() {
      _player = null;
      _bottom = 90.0;
    });

    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        setState(
          () {
            widget.sounds[index]['current'] = true;
            isPlay = true;
            _player = CustomPlayer(
              onDismissed: (direction) {
                setState(
                  () {
                    widget.stop == null ? stop() : widget.stop!();
                    widget.sounds[index]['current'] = false;
                    isPlay = false;
                  },
                );
              },
              title: widget.sounds[index]['title'],
              url: widget.sounds[index]['url'],
              id: widget.sounds[index]['id'],
              routName: widget.routName,
              whenComplete: () {
                if (index < widget.sounds.length - 1) {
                  widget.sounds[index]['current'] = false;
                  playAll(index + 1);
                } else {
                  if (widget.repeat) {
                    widget.sounds[index]['current'] = false;
                    playAll(0);
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  bool chek() {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: _bottom),
          child: widget.sounds.isEmpty
              ? Center(
                  child: Text(
                    widget.compilationId == null
                        ? 'Как только ты запишешь аудио,'
                            '\nони появится здесь.'
                        : 'Упс, видимо все аудио из этой'
                            '\nподборки были удалены.'
                            '\nНо ее все еще можно'
                            '\nпополнять новыми.',
                    style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.sounds.length,
                  itemBuilder: (context, index) {
                    Color color = widget.sounds[index]['current']
                        ? const Color(0xffF1B488)
                        : AppColor.active;

                    return Column(
                      children: [
                        SoundContainer(
                          color: color,
                          title: widget.sounds[index]['title'],
                          time: (widget.sounds[index]['time'] / 60)
                              .toStringAsFixed(1),
                          buttonRight: Align(
                            alignment: const AlignmentDirectional(0.9, -1.0),
                            child: widget.isPopup
                                ? PopupMenuSoundContainer(
                                    size: 30.0,
                                    title: widget.sounds[index]['title'],
                                    id: widget.sounds[index]['id'],
                                    url: widget.sounds[index]['url'],
                                    onDelete: () {
                                      widget.compilationId == null
                                          ? _onDeleteInAudio(index)
                                          : _onDeleteInCompilation(
                                              context,
                                              index,
                                            );
                                      widget.onDelete();
                                    },
                                    page: widget.page,
                                    onRename: (title) {
                                      widget.sounds[index]['title'] = title;
                                      setState(() {});
                                    },
                                  )
                                : CustomCheckBox(
                                    color: Colors.black87,
                                    value: widget.sounds[index]['chek'],
                                    onTap: () {
                                      setState(
                                        () {
                                          widget.sounds[index]['chek'] =
                                              !widget.sounds[index]['chek'];
                                        },
                                      );
                                    },
                                  ),
                          ),
                          onTap: () {
                            widget.play == null
                                ? play(index)
                                : widget.play!(index);
                          },
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
                      ],
                    );
                  }),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: _player,
        ),
      ],
    );
  }
}
