import 'package:audio_stories/pages/main_pages/widgets/popup_menu_sound_container.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/local_db.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import '../../main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import '../../main_pages/widgets/button_menu.dart';
import '../../main_pages/widgets/player_container.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../../play_page/play_page.dart';

class AudioPage extends StatefulWidget {
  static const routName = '/audio';

  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  double _bottom = 10.0;
  Widget _player = const Text('');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(LocalDB.uid)
            .collection('sounds')
            .where('deleted', isEqualTo: false)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<bool> _current = [];
            final int length = snapshot.data.docs.length;
            if (_current.isEmpty) {
              for (int i = 0; i < length; i++) {
                _current.add(false);
              }
            }
            return Stack(
              children: [
                Column(
                  children: const [
                    Background(
                      image: AppIcons.upBlue,
                      height: 275.0,
                      child: Align(
                        alignment: AlignmentDirectional(-1.1, -0.9),
                        child: ButtonMenu(),
                      ),
                    ),
                  ],
                ),
                const Align(
                  alignment: AlignmentDirectional(0.0, -0.91),
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
                  alignment: const AlignmentDirectional(1.0, -0.98),
                  child: TextButton(
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {},
                    child: const Text(
                      '...',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          letterSpacing: 3.0),
                    ),
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
                Align(
                  alignment: const AlignmentDirectional(-0.9, -0.55),
                  child: Text(
                    '${snapshot.data.docs.length} аудио'
                    '\n0 часов',
                    style: const TextStyle(
                      fontFamily: 'TTNormsL',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.9, -0.55),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColor.greyDisActive,
                      minimumSize: const Size(100.0, 46.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onPressed: () {},
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
                ),
                Align(
                  alignment: const AlignmentDirectional(0.45, -0.55),
                  child: Stack(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(168.0, 46.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {},
                        child: const Align(
                          widthFactor: 0.6,
                          heightFactor: 0.0,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Запустить все',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: 'TTNormsL',
                              color: AppColor.active,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        child: Image(
                          image: Image.asset(AppIcons.play).image,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 225.0, bottom: _bottom),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Color color = _current[index]
                          ? const Color(0xffF1B488)
                          : AppColor.active;
                      final String url = snapshot.data.docs[index]['song'];
                      final String id = snapshot.data.docs[index].id;
                      final String title = snapshot.data.docs[index]['title'];
                      return Column(
                        children: [
                          SoundContainer(
                            color: color,
                            title: title,
                            time: (snapshot.data.docs[index]['time'] / 60)
                                .toStringAsFixed(1),
                            buttonRight: Align(
                              alignment: const AlignmentDirectional(0.9, -1.0),
                              child: PopupMenuSoundContainer(
                                size: 30.0,
                                title: title,
                                id: id,
                                url: url,
                              ),
                            ),
                            onTap: () {
                              if (!_current[index]) {
                                for (int i = 0; i < length; i++) {
                                  _current[i] = false;
                                }
                                setState(() {
                                  _player = const Text('');
                                  _bottom = 85.0;
                                });

                                Future.delayed(const Duration(milliseconds: 50),
                                    () {
                                  setState(() {
                                    _current[index] = true;
                                    _player = PlayerContainer(
                                      title: title,
                                      color: AppColor.active,
                                      url: url,
                                      id: id,
                                      onPressed: () {
                                        setState(() {
                                          _player = const Text('');
                                        });
                                        Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                PlayPage(
                                              url: url,
                                              title: title,
                                              id: id,
                                              page: AudioPage.routName,
                                            ),
                                          ),
                                        );
                                        context.read<BlocIndex>().add(
                                              NoColor(),
                                            );
                                      },
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
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _player,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: const [
                Background(
                  image: AppIcons.upBlue,
                  height: 275.0,
                  child: Align(
                    alignment: AlignmentDirectional(-1.1, -0.9),
                    child: ButtonMenu(),
                  ),
                ),
              ],
            );
          }
        });
  }
}
