import 'package:audio_stories/widgets/uncategorized/sound_container.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_color.dart';
import '../menu/popup_menu_sound_container.dart';
import 'custom_checkbox.dart';
import 'custom_player.dart';

class SearchSoundList extends StatefulWidget {
  const SearchSoundList({
    Key? key,
    required this.sounds,
    required this.search,
    required this.routName,
    required this.searchText,
    required this.isPopup,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final List<int> search;
  final String routName;
  final String searchText;
  final bool isPopup;

  @override
  State<SearchSoundList> createState() => _SearchSoundListState();
}

class _SearchSoundListState extends State<SearchSoundList> {
  Widget? _player;
  double _bottom = 10.0;

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
              _player = CustomPlayer(
                onDismissed: (direction) {
                  _stop();
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
              ? const Center(
                  child: Text(
                    'Как только ты запишешь'
                    '\nаудио, она появится здесь.',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : widget.searchText != '' && widget.search.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.searchText == ''
                          ? widget.sounds.length
                          : widget.search.length,
                      itemBuilder: (context, index) {
                        final int i = widget.searchText == ''
                            ? index
                            : widget.search[index];
                        Color color = widget.sounds[i]['current']
                            ? const Color(0xffF1B488)
                            : AppColor.active;

                        return Column(
                          children: [
                            SoundContainer(
                              color: color,
                              title: widget.sounds[i]['title'],
                              time: (widget.sounds[i]['time'] / 60)
                                  .toStringAsFixed(1),
                              buttonRight: Align(
                                alignment:
                                    const AlignmentDirectional(0.9, -1.0),
                                child: widget.isPopup
                                    ? PopupMenuSoundContainer(
                                        size: 30.0,
                                        title: widget.sounds[index]['title'],
                                        id: widget.sounds[index]['id'],
                                        url: widget.sounds[index]['url'],
                                        onDelete: () {
                                          if (widget.sounds[i]['current']) {
                                            setState(() {
                                              _player = null;
                                            });
                                          }
                                          widget.sounds.removeAt(i);
                                        },
                                        onRename: (title) {
                                          widget.sounds[index]['title'] = title;
                                          setState(() {});
                                        },
                                      )
                                    : CustomCheckBox(
                                        color: Colors.black87,
                                        value: widget.sounds[i]['chek'],
                                        onTap: () {
                                          setState(
                                            () {
                                              widget.sounds[i]['chek'] =
                                                  !widget.sounds[i]['chek'];
                                            },
                                          );
                                        },
                                      ),
                              ),
                              onTap: () => _play(i),
                            ),
                            const SizedBox(
                              height: 7.0,
                            ),
                          ],
                        );
                      },
                    ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: _player,
        ),
      ],
    );
  }
}
