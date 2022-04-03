import 'package:audio_stories/main_page/widgets/menu/popup_menu_sound_container.dart';
import 'package:audio_stories/main_page/widgets/uncategorized/sound_container.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/app_color.dart';
import '../../../../widgets/uncategorized/custom_player.dart';

//ignore: must_be_immutable
class SoundsList extends StatefulWidget {
  const SoundsList({
    Key? key,
    required this.sounds,
    required this.routName,
    required this.onDelete,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function() onDelete;
  final String routName;

  @override
  State<SoundsList> createState() => SoundsListState();
}

class SoundsListState extends State<SoundsList> {
  Widget? _player;
  double _bottom = 10.0;
  bool isPlay = false;

  void _onDelete(int index) {
    _player = null;
    widget.sounds.removeAt(index);
  }

  void _play(int index) {
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
                onDismissed: (direction) => _stop(),
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

  void _stop() {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: _bottom),
          child: widget.sounds.isEmpty
              ? Center(
                  child: Text(
                    'Как только ты запишешь аудио,'
                    '\nони появится здесь.',
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
                            child: PopupMenuSoundContainer(
                              size: 30.0,
                              title: widget.sounds[index]['title'],
                              id: widget.sounds[index]['id'],
                              url: widget.sounds[index]['url'],
                              onDelete: () {
                                _onDelete(index);
                                widget.onDelete();
                              },
                              page: widget.routName,
                              onRename: (title) {
                                widget.sounds[index]['title'] = title;
                                setState(() {});
                              },
                            ),
                          ),
                          onTap: () {
                            _play(index);
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
