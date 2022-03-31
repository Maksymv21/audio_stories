import 'package:audio_stories/repositories/global_repository.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../../utils/database.dart';
import '../../../../../utils/local_db.dart';
import '../../../../main_page.dart';
import '../../../../widgets/button_menu.dart';
import '../../../../widgets/custom_checkbox.dart';
import '../../../../widgets/custom_player.dart';
import '../../../../widgets/player_container.dart';
import '../../../../widgets/popup_menu_pick_few.dart';
import '../../../../widgets/popup_menu_sound_container.dart';
import '../../../../widgets/sound_container.dart';
import '../../../compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../../compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../../compilation_pages/compilation_page/compilation_page.dart';


class AudioPage extends StatefulWidget {
  static const routName = '/audio';

  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  List<bool> current = [];
  List<bool> chek = [];
  List currentId = [];
  double _bottom = 10.0;
  Widget _player = const Text('');
  bool _repeat = false;
  bool _pickFew = false;
  bool _isPlayAll = false;

  void _playAll(
    AsyncSnapshot snapshot,
    int length,
  ) {
    if (FirebaseAuth.instance.currentUser != null) {
      if (current.isEmpty) {
        GlobalRepo.showSnackBar(
          context: context,
          title: 'Отсутствуют аудио для проигрования',
        );
      } else {
        if (!current.contains(true)) {
          setState(() {
            _isPlayAll = !_isPlayAll;
            _player = _next(
              index: 0,
              length: length,
              snapshot: snapshot,
            );
          });
        } else {
          setState(() {
            _isPlayAll = !_isPlayAll;
            _player = const Text('');
            _bottom = 10.0;
            for (int i = 0; i < current.length; i++) {
              current[i] = false;
            }
          });
        }
      }
    }
  }

  void _play(
    int index,
    int length,
    String url,
    String id,
    String title,
  ) {
    if (!current[index]) {
      for (int i = 0; i < length; i++) {
        current[i] = false;
      }
      setState(() {
        _player = const Text('');
        _bottom = 90.0;
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          current[index] = true;
          _player = CustomPlayer(
            onDismissed: (direction) {
              setState(() {
                _player = const Text('');
                _bottom = 10.0;
                _isPlayAll = false;
                debugPrint(_bottom.toString());
                current[index] = false;
              });
            },
            url: url,
            id: id,
            title: title,
            routName: AudioPage.routName,
          );
        });
      });
    }
  }

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
          if (chek.isEmpty) {
            for (int i = 0; i < length; i++) {
              chek.add(false);
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
                alignment: const AlignmentDirectional(0.95, -0.96),
                child: _pickFew ? _popupMenu(snapshot) : _popupPickFew(),
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
                        _playAllButton(width, length, snapshot),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 8,
                  ),
                ],
              ),
              snapshot.data.docs.length == 0 ||
                      FirebaseAuth.instance.currentUser == null
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100.0),
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
                      child: _listSound(snapshot, length),
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

  Widget _playAllButton(
    double width,
    int length,
    AsyncSnapshot snapshot,
  ) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: width * 0.29,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    _repeat ? AppColor.greyActive : AppColor.greyDisActive,
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
          onPressed: () => _playAll(snapshot, length),
          child: Align(
            widthFactor: 0.6,
            heightFactor: 0.0,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _isPlayAll ? 'Остановить' : 'Запустить все',
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
              onPressed: () => _playAll(snapshot, length),
              icon: Image.asset(
                current.contains(true) ? AppIcons.pauseRecord : AppIcons.play,
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

  Widget _listSound(
    AsyncSnapshot snapshot,
    int length,
  ) {
    return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        Color color =
            current[index] ? const Color(0xffF1B488) : AppColor.active;
        final String url = snapshot.data.docs[index]['song'];
        final String id = snapshot.data.docs[index].id;
        final String title = snapshot.data.docs[index]['title'];
        return Column(
          children: [
            SoundContainer(
              color: color,
              title: title,
              time: (snapshot.data.docs[index]['time'] / 60).toStringAsFixed(1),
              buttonRight: Align(
                alignment: const AlignmentDirectional(0.9, -1.0),
                child: _pickFew
                    ? CustomCheckBox(
                        value: chek[index],
                        onTap: () {
                          setState(() {
                            chek[index] = !chek[index];
                          });
                        },
                        color: Colors.black87,
                      )
                    : PopupMenuSoundContainer(
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
              onTap: () => _play(
                index,
                length,
                url,
                id,
                title,
              ),
            ),
            const SizedBox(
              height: 7.0,
            ),
          ],
        );
      },
    );
  }

  Widget _popupPickFew() {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) {
          setState(() {
            _pickFew = true;
          });
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0,
          child: Text(
            'Выбрать несколько',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  Widget _popupMenu(AsyncSnapshot snapshot) {
    return PopupMenuPickFew(
      onSelected: (value) async {
        if (value == 0) {
          setState(() {
            _pickFew = false;
          });
        }
        if (value == 1) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) currentId.add(snapshot.data.docs[i]['id']);
            }
            MainPage.globalKey.currentState!
                .pushReplacementNamed(CompilationPage.routName);
            context.read<CompilationBloc>().add(
                  ToAddInCompilation(
                    listId: currentId,
                  ),
                );
            context.read<BlocIndex>().add(
                  ColorCategory(),
                );
          }
        }
        if (value == 2) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            List<String> url = [];
            List<String> title = [];
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                url.add(snapshot.data.docs[i]['song']);
                title.add(snapshot.data.docs[i]['title']);

                setState(() {
                  chek[i] = false;
                });
              }
            }
            GlobalRepo.share(url, title);
          }
        }
        if (value == 3) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                GlobalRepo.download(
                  snapshot.data.docs[i]['song'],
                  snapshot.data.docs[i]['title'],
                ).then((value) => {
                      GlobalRepo.showSnackBar(
                        context: context,
                        title: 'Файл сохранен.'
                            '\nDownload/${snapshot.data.docs[i]['title']}.aac',
                      ),
                    });

                setState(() {
                  chek[i] = false;
                });
              }
            }
          }
        }
        if (value == 4) {
          if (!chek.contains(true)) {
            _choiseSnackBar(context);
          } else {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (chek[i]) {
                Database.createOrUpdateSound(
                  {
                    'deleted': true,
                    'dateDeleted': Timestamp.now(),
                    'id': snapshot.data.docs[i]['id'],
                  },
                );
                setState(() {
                  chek[i] = false;
                });
              }
            }
          }
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
          _isPlayAll = false;
          current[index] = false;
        });
      },
      child: PlayerContainer(
        title: title,
        url: url,
        id: id,
        onPressed: () => GlobalRepo.toPlayPage(
          context: context,
          url: url,
          title: title,
          id: id,
          routName: AudioPage.routName,
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

  void _choiseSnackBar(BuildContext context) {
    GlobalRepo.showSnackBar(
      context: context,
      title: 'Перед этим нужно сделать выбор',
    );
  }
}