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
  List<bool> current = [];
  double _bottom = 10.0;
  Widget _player = const Text('');
  bool _repeat = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

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
          final int length = snapshot.data.docs.length;
          if (current.isEmpty) {
            for (int i = 0; i < length; i++) {
              current.add(false);
            }
          }
          return Stack(
            children: [
              Column(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Background(
                      image: AppIcons.upBlue,
                      height: 275.0,
                      child: Align(
                        alignment: AlignmentDirectional(-1.1, -0.9),
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
                        color: Colors.white, fontSize: 48, letterSpacing: 3.0),
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
              Column(
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.035,
                        ),
                        Text(
                          '$length аудио'
                          '\n0 часов',
                          style: const TextStyle(
                            fontFamily: 'TTNormsL',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.25,
                        ),
                        Stack(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.29,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _repeat
                                        ? AppColor.greyActive
                                        : AppColor.greyDisActive,
                                    minimumSize: const Size(100.0, 46.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _repeat = !_repeat;
                                    });
                                  },
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
                                if (current.isEmpty) {
                                  // show snack bar
                                } else {
                                  if (!current.contains(true)) {
                                    setState(() {
                                      _player = _next(
                                        index: 0,
                                        length: length,
                                        snapshot: snapshot,
                                      );
                                    });
                                  }
                                }
                              },
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
                            Transform.scale(
                              scale: 1.3,
                              child: ColorFiltered(
                                child: IconButton(
                                  onPressed: () {
                                    if (current.isEmpty) {
                                      // show snack bar
                                    } else {
                                      if (!current.contains(true)) {
                                        setState(() {
                                          _player = _next(
                                            index: 0,
                                            length: length,
                                            snapshot: snapshot,
                                          );
                                        });
                                      }
                                    }
                                  },
                                  icon: Image.asset(
                                    current.contains(true)
                                        ? AppIcons.pauseRecord
                                        : AppIcons.play,
                                  ),
                                ),
                                colorFilter: const ColorFilter.mode(
                                  AppColor.active,
                                  BlendMode.srcATop,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 8,
                  ),
                ],
              ),
              snapshot.data.docs.length == 0
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 100.0),
                        child: Text(
                          'Как только ты запишешь аудио,'
                          '\nони появится здесь.',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 225.0, bottom: _bottom),
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Color color = current[index]
                              ? const Color(0xffF1B488)
                              : AppColor.active;
                          final String url = snapshot.data.docs[index]['song'];
                          final String id = snapshot.data.docs[index].id;
                          final String title =
                              snapshot.data.docs[index]['title'];
                          return Column(
                            children: [
                              SoundContainer(
                                color: color,
                                title: title,
                                time: (snapshot.data.docs[index]['time'] / 60)
                                    .toStringAsFixed(1),
                                buttonRight: Align(
                                  alignment:
                                      const AlignmentDirectional(0.9, -1.0),
                                  child: PopupMenuSoundContainer(
                                    size: 30.0,
                                    title: title,
                                    id: id,
                                    url: url,
                                    onDelete: () {
                                      if (current[index]) {
                                        setState(() {
                                          _player = const Text('');
                                        });
                                      }
                                      current.removeAt(index);
                                    },
                                  ),
                                ),
                                onTap: () {
                                  if (!current[index]) {
                                    for (int i = 0; i < length; i++) {
                                      current[i] = false;
                                    }
                                    setState(() {
                                      _player = const Text('');
                                      _bottom = 90.0;
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 50), () {
                                      setState(() {
                                        current[index] = true;
                                        _player = Dismissible(
                                          key: const Key(''),
                                          direction: DismissDirection.down,
                                          onDismissed: (direction) {
                                            setState(() {
                                              _player = const Text('');
                                              _bottom = 10.0;
                                              debugPrint(_bottom.toString());
                                              current[index] = false;
                                            });
                                          },
                                          child: PlayerContainer(
                                            title: title,
                                            url: url,
                                            id: id,
                                            onPressed: () => _onPressed(
                                              url: url,
                                              title: title,
                                              id: id,
                                            ),
                                          ),
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
      },
    );
  }

  Widget _next({
    required int index,
    required int length,
    required AsyncSnapshot snapshot,
  }) {
    final String title = snapshot.data.docs[index]['title'];
    final String url = snapshot.data.docs[index]['song'];
    final String id = snapshot.data.docs[index].id;
    setState(() {
      current[index] = true;
    });

    return Dismissible(
      key: const Key(''),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        setState(() {
          _player = const Text('');
          _bottom = 10.0;
          current[index] = false;
        });
      },
      child: PlayerContainer(
        title: title,
        url: url,
        id: id,
        onPressed: () => _onPressed(
          url: url,
          title: title,
          id: id,
        ),
        whenComplete: () {
          if (index + 1 < length) {
            setState(() {
              _player = const Text('');
              current[index] = false;
            });
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                _player = _next(
                  index: index + 1,
                  length: length,
                  snapshot: snapshot,
                );
              });
            });
          }
          if (index + 1 == length) {
            if (_repeat) {
              setState(() {
                _player = const Text('');
                current[index] = false;
              });
              Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {
                  _player = _next(
                    index: 0,
                    length: length,
                    snapshot: snapshot,
                  );
                });
              });
            }
          }
        },
      ),
    );
  }

  void _onPressed({
    required String url,
    required String title,
    required String id,
  }) {
    setState(() {
      _player = const Text('');
    });
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PlayPage(
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
  }
}
