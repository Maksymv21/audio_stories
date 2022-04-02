import 'package:audio_stories/main_page/pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/repositories/global_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../../main.dart';
import '../../../../../resources/app_color.dart';
import '../../../../../resources/app_icons.dart';
import '../../../../../resources/app_images.dart';
import '../../../../../utils/database.dart';
import '../../../../../utils/local_db.dart';
import '../../../../../widgets/background.dart';
import '../../../../widgets/uncategorized/custom_checkbox.dart';
import '../../../../widgets/uncategorized/player_container.dart';
import '../../../../widgets/uncategorized/sound_container.dart';
import '../widgets/delete_bottom_bar.dart';
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

  void _rees(AsyncSnapshot snapshot, int length) {
    for (int i = 0; i < length; i++) {
      if (chek.reversed.toList()[i]) {
        final String id = snapshot.data.docs[i].id;
        Database.createOrUpdateSound(
          {
            'deleted': false,
            'id': id,
          },
        );
      }
    }
    setState(() {
      chek = [];
      current = [];
      _player = const Text('');
    });
  }

  void _delete(AsyncSnapshot snapshot, int length) {
    for (int i = 0; i < length; i++) {
      if (chek.reversed.toList()[i]) {
        final String path = snapshot.data.docs[i].id;
        final String title = snapshot.data.docs[i]['title'];
        final String date = snapshot.data.docs[i]['date'].toString();
        final int memory = snapshot.data.docs[i]['memory'];

        Database.deleteSound(path, title, date, memory);
      }
    }
    setState(() {
      chek = [];
      current = [];
      _player = const Text('');
    });
  }

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

        if (snapshot.data?.docs.length == 0 ||
            FirebaseAuth.instance.currentUser == null) {
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
                    image: AppImages.upSearch,
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
                            rees: () => _rees(snapshot, length),
                            delete: () => _delete(snapshot, length),
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
          top: 60.0,
          bottom: widget.edit ? _bottomEdit : _bottom,
          left: 20.0,
          right: 20.0,
        ),
        child: GroupedListView<dynamic, String>(
          elements: snapshot.data.docs,
          groupBy: (element) =>
              element['dateDeleted'].toDate().toString().substring(0, 10),
          groupComparator: (value1, value2) => value1.compareTo(value2),
          order: GroupedListOrder.DESC,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _convertDate(value),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xff3A3A55).withOpacity(0.5),
              ),
            ),
          ),
          indexedItemBuilder: (c, element, index) {
            Color color =
                current[index] ? const Color(0xffF1B488) : AppColor.active;

            autoDelete(
              element['dateDeleted'],
              element['id'],
              element['title'],
              element['date'].toString(),
              element['memory'],
            );

            return Column(
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                SoundContainer(
                  color: color,
                  title: element['title'],
                  time: (element['time'] / 60).toStringAsFixed(1),
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
                          element['id'],
                          element['title'],
                          element['date'].toString(),
                          element['memory'],
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
                              title: element['title'],
                              url: element['song'],
                              id: element['id'],
                              onPressed: () => GlobalRepo.toPlayPage(
                                context: context,
                                title: element['title'],
                                url: element['song'],
                                id: element['id'],
                                routName: RecentlyDeletedPage.routName,
                              ),
                            ),
                          );
                        });
                      });
                    }
                  },
                ),
                const SizedBox(height: 4.0),
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
      onSelected: (value) {
        if (value == 2) {
          for (int i = 0; i < length; i++) {
            final String id = snapshot.data.docs[i].id;
            Database.createOrUpdateSound(
              {
                'deleted': false,
                'id': id,
              },
            );
          }
          _player = const Text('');
        }
      },
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
              final String path = snapshot.data.docs[i].id;
              final String title = snapshot.data.docs[i]['title'];
              final String date = snapshot.data.docs[i]['date'].toString();
              final int memory = snapshot.data.docs[i]['memory'];
              Database.deleteSound(path, title, date, memory);
            }
            _player = const Text('');
          },
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'Восстановить все',
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

  String _convertDate(String date) {
    final String result = date.substring(8, 10) +
        '.' +
        date.substring(5, 7) +
        '.' +
        date.substring(2, 4);
    return result;
  }
}
