import 'package:audio_stories/widgets/menu/popup_menu_sound_container.dart';
import 'package:audio_stories/widgets/uncategorized/sound_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/app_color.dart';
import '../../../../../resources/app_icons.dart';
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
  final void Function(int) onDelete;
  final String routName;

  @override
  State<SoundsList> createState() => SoundsListState();
}

class SoundsListState extends State<SoundsList> {
  Widget? _player;
  double _bottom = 10.0;
  bool isPlay = false;

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
          child: widget.sounds.isEmpty ||
                  FirebaseAuth.instance.currentUser == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      top: 25.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Как только ты запишешь'
                          '\nаудио, она появится здесь.',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Image(
                          image: Image.asset(AppIcons.arrow).image,
                        ),
                      ],
                    ),
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
                                _player = null;
                                widget.onDelete(index);
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
