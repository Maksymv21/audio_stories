import 'package:audio_stories/pages/main_pages/widgets/custom_checkbox.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/widgets/delete_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../resources/app_color.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/widgets/player_container.dart';
import '../../main_pages/widgets/sound_container.dart';
import '../../play_page/play_page.dart';
import 'edit_deleted_page.dart';

//ignore: must_be_immutable
class GeneralDeletedPage extends StatefulWidget {
  Widget button;
  bool edit;

  GeneralDeletedPage({
    Key? key,
    required this.button,
    required this.edit,
  }) : super(key: key);

  @override
  State<GeneralDeletedPage> createState() => _GeneralDeletedPageState();
}

class _GeneralDeletedPageState extends State<GeneralDeletedPage> {
  List<bool> chek = [];
  List<bool> current = [];
  double _bottom = 10.0;
  double _bottomEdit = 80.0;

  Widget _player = const Text('');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .where('deleted', isEqualTo: true)
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        int length = 0;
        Widget _list;
        Widget _popup;

        if (snapshot.data?.docs.length == 0) {
          _list = const Padding(
            padding: EdgeInsets.only(
              top: 200.0,
            ),
            child: Text(
              'Как только ты удалишь'
              '\nаудио, она появится здесь.',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          _list = _soundList(snapshot);
        }
        if (snapshot.hasData) {
          length = snapshot.data.docs.length;
          _popup = widget.edit
              ? _popupEditMenu(snapshot, length)
              : _popupMenu(snapshot, length);
        } else {
          _popup = Container();
        }

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Background(
                    height: 375.0,
                    image: AppIcons.upSearch,
                    child: Stack(
                      children: [
                        widget.button,
                        Align(
                          alignment: const AlignmentDirectional(1.0, -1.15),
                          child: _popup,
                        ),
                      ],
                    ),
                  ),
                ),
                widget.edit
                    ? Expanded(
                        flex: 6,
                        child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: DeleteBottomBar(
                            rees: () {
                              for (int i = 0; i < length; i++) {
                                if (chek[i]) {
                                  final String id = snapshot.data.docs[i].id;
                                  Database.createOrUpdateSound(
                                    {
                                      'deleted': false,
                                      'id': id,
                                    },
                                  );
                                  chek[i] = false;
                                }
                              }
                              setState(() {
                                _player = const Text('');
                              });
                            },
                            delete: () {
                              for (int i = 0; i < length; i++) {
                                if (chek[i]) {
                                  final String path = snapshot.data.docs[i].id;
                                  final String title =
                                      snapshot.data.docs[i]['title'];
                                  final String date =
                                      snapshot.data.docs[i]['date'].toString();
                                  final int memory =
                                      snapshot.data.docs[i]['memory'];
                                  Database.deleteSound(
                                      path, title, date, memory);
                                  chek[i] = false;
                                }
                              }
                              setState(() {
                                _player = const Text('');
                              });
                            },
                          ),
                        ),
                      )
                    : const Spacer(
                        flex: 5,
                      ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Недавно'
                      '\nудаленные',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 36.0,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _list,
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: widget.edit ? 80.0 : 10.0,
                ),
                child: _player,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _soundList(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      final int length = snapshot.data.docs.length;
      if (chek.isEmpty) {
        for (int i = 0; i < length; i++) {
          chek.add(false);
        }
      }

      if (current.isEmpty) {
        for (int i = 0; i < length; i++) {
          current.add(false);
        }
      }
      return Padding(
        padding: EdgeInsets.only(
          top: 85.0,
          bottom: widget.edit ? _bottomEdit : _bottom,
        ),
        child: ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            Color color =
                current[index] ? const Color(0xffF1B488) : AppColor.active;

            final String path = snapshot.data.docs[index].id;
            final String title = snapshot.data.docs[index]['title'];
            final String date = snapshot.data.docs[index]['date'].toString();
            final String url = snapshot.data.docs[index]['song'];
            final int memory = snapshot.data.docs[index]['memory'];

            autoDelete(
              snapshot.data.docs[index]['dateDeleted'],
              path,
              title,
              date,
              memory,
            );

            return Column(
              children: [
                SoundContainer(
                  color: color,
                  title: title,
                  time: (snapshot.data.docs[index]['time'] / 60)
                      .toStringAsFixed(1),
                  buttonRight: widget.edit
                      ? CustomCheckBox(
                          color: Colors.black87,
                          value: chek[index],
                          onTap: () {
                            setState(() {
                              chek[index] = !chek[index];
                            });
                          })
                      : _deletedButton(
                          path,
                          title,
                          date,
                          memory,
                        ),
                  onTap: () {
                    if (!current[index]) {
                      for (int i = 0; i < length; i++) {
                        current[i] = false;
                      }
                      setState(() {
                        _player = const Text('');
                        widget.edit ? _bottomEdit = 165.0 : _bottom = 90.0;
                      });

                      Future.delayed(const Duration(milliseconds: 50), () {
                        setState(() {
                          current[index] = true;
                          _player = Dismissible(
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
                              id: path,
                              onPressed: () {
                                setState(() {
                                  _player = const Text('');
                                });
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => PlayPage(
                                      url: url,
                                      title: title,
                                      id: path,
                                      page: RecentlyDeletedPage.routName,
                                    ),
                                  ),
                                );
                              },
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
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _popupMenu(
    AsyncSnapshot snapshot,
    int length,
  ) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: const Text(
            'Выбрать несколько',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {
            MyApp.firstKey.currentState!.pushNamed(
              EditDeletedPage.routName,
            );
          },
        ),
        PopupMenuItem(
          child: const Text(
            'Удалить все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {
            for (int i = 0; i < length; i++) {
              final String path = snapshot.data.docs[i].listId;
              final String title = snapshot.data.docs[i]['title'];
              final String date = snapshot.data.docs[i]['date'].toString();
              final int memory = snapshot.data.docs[i]['memory'];
              Database.deleteSound(path, title, date, memory);
            }
            _player = const Text('');
          },
        ),
        PopupMenuItem(
          child: const Text(
            'Восстановить все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {
            for (int i = 0; i < length; i++) {
              final String id = snapshot.data.docs[i].listId;
              Database.createOrUpdateSound(
                {
                  'deleted': false,
                  'id': id,
                },
              );
            }
            _player = const Text('');
          },
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 60.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  Widget _popupEditMenu(
    AsyncSnapshot snapshot,
    int length,
  ) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: const Text(
            'Выбрать все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {
            setState(() {
              for (int i = 0; i < length; i++) {
                chek[i] = true;
              }
            });
          },
        ),
        PopupMenuItem(
          child: const Text(
            'Сбросить выбор',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {
            setState(() {
              for (int i = 0; i < length; i++) {
                chek[i] = false;
              }
            });
          },
        ),
      ],
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 60.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  Widget _deletedButton(
    String path,
    String title,
    String date,
    int memory,
  ) {
    return Align(
      alignment: const AlignmentDirectional(0.95, 0.0),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Database.deleteSound(
            path,
            title,
            date,
            memory,
          );
          _player = const Text('');
        },
        icon: Image.asset(
          AppIcons.delete,
          color: Colors.black,
        ),
        iconSize: 20.0,
      ),
    );
  }

  void autoDelete(
    Timestamp timestamp,
    String path,
    String title,
    String date,
    int memory,
  ) {
    final DateTime now = DateTime.now();
    final DateTime timeDeleted = timestamp.toDate();

    if (now.difference(timeDeleted).inDays >= 15) {
      Database.deleteSound(path, title, date, memory);
    }
  }
}
