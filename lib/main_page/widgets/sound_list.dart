import 'package:audio_stories/main_page/widgets/sound_container.dart';
import 'package:flutter/material.dart';

import '../../resources/app_color.dart';
import 'custom_checkbox.dart';
import 'custom_player.dart';

//ignore: must_be_immutable
class SoundsList extends StatefulWidget {
  final List<Map<String, dynamic>> sounds;
  final String routName;

  const SoundsList({
    Key? key,
    required this.sounds,
    required this.routName,
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
          child: ListView.builder(
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
                        child: CustomCheckBox(
                          color: Colors.black87,
                          value: widget.sounds[index]['chek'],
                          onTap: () {
                            setState(() {
                              widget.sounds[index]['chek'] =
                              !widget.sounds[index]['chek'];
                            });
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

                          Future.delayed(const Duration(milliseconds: 50), () {
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