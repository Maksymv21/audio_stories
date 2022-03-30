import 'package:audio_stories/main_page/widgets/popup_menu_sound_container.dart';
import 'package:audio_stories/main_page/widgets/sound_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../repositories/global_repository.dart';
import '../../resources/app_color.dart';
import '../../utils/database.dart';
import 'custom_checkbox.dart';
import 'custom_player.dart';

//ignore: must_be_immutable
class SoundsList extends StatefulWidget {
  final List<Map<String, dynamic>> sounds;
  final String routName;
  final bool isPopup;
  final String compilationId;
  final String? page;

  const SoundsList({
    Key? key,
    required this.sounds,
    required this.routName,
    required this.isPopup,
    required this.compilationId,
    this.page,
  }) : super(key: key);

  @override
  State<SoundsList> createState() => SoundsListState();
}

class SoundsListState extends State<SoundsList> {
  Widget _player = const Text('');
  double _bottom = 10.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: _bottom),
          child: widget.sounds.isEmpty
              ? const Center(
                  child: Text(
                    'Упс, видимо все аудио из этой'
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
                                                [widget.sounds[index]['id']]),
                                          },
                                          widget.compilationId,
                                          widget.sounds[index]['id'],
                                        );
                                        widget.sounds.removeAt(index);
                                      }
                                    },
                                    page: widget.page,
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
                            if (!widget.sounds[index]['current']) {
                              for (int i = 0; i < widget.sounds.length; i++) {
                                widget.sounds[i]['current'] = false;
                              }
                              setState(() {
                                _player = const Text('');
                                _bottom = 90.0;
                              });

                              Future.delayed(const Duration(milliseconds: 50),
                                  () {
                                setState(() {
                                  widget.sounds[index]['current'] = true;
                                  _player = CustomPlayer(
                                    onDismissed: (direction) {
                                      setState(() {
                                        _player = const Text('');
                                        _bottom = 10.0;
                                        widget.sounds[index]['current'] = false;
                                      });
                                    },
                                    title: widget.sounds[index]['title'],
                                    url: widget.sounds[index]['url'],
                                    id: widget.sounds[index]['id'],
                                    routName: widget.routName,
                                  );
                                });
                              });
                            }
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
