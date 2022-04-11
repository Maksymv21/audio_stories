import 'package:audio_stories/pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../main.dart';
import '../../../../resources/app_color.dart';
import '../../../../resources/app_icons.dart';
import '../../../../resources/app_images.dart';
import '../../../../utils/database.dart';
import '../../../../utils/local_db.dart';
import '../../../widgets/uncategorized/custom_checkbox.dart';
import '../../../widgets/uncategorized/custom_player.dart';
import '../../../widgets/uncategorized/sound_container.dart';
import 'widgets/delete_bottom_bar.dart';
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
  List<Map<String, dynamic>> sounds = [];

  void _create(AsyncSnapshot snapshot) {
    if (sounds.isEmpty) {
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        sounds.add(
          {
            'current': false,
            'chek': false,
            'title': snapshot.data.docs[i]['title'],
            'time': snapshot.data.docs[i]['time'],
            'id': snapshot.data.docs[i]['id'],
            'url': snapshot.data.docs[i]['song'],
            'memory': snapshot.data.docs[i]['memory'],
            'date': snapshot.data.docs[i]['date'],
            'dateDeleted': snapshot.data.docs[i]['dateDeleted'],
          },
        );
      }
    }
  }

  void _rees() {
    for (int i = sounds.length - 1; i >= 0; i = i - 1) {
      if (sounds[i]['chek']) {
        Database.createOrUpdateSound(
          {
            'deleted': false,
            'id': sounds[i]['id'],
          },
        );
      }
      Future.delayed(
          const Duration(
            milliseconds: 1000,
          ), () {
        setState(() {
          sounds = [];
        });
      });
    }
  }

  void _delete() {
    for (int i = sounds.length - 1; i >= 0; i = i - 1) {
      if (sounds[i]['chek']) {
        Database.deleteSound(
          sounds[i]['id'],
          sounds[i]['title'],
          sounds[i]['date'].toString(),
          sounds[i]['memory'],
        );
        Future.delayed(
            const Duration(
              milliseconds: 1000,
            ), () {
          setState(() {
            sounds = [];
          });
        });
      }
    }
  }

  void _cancelAll() {
    for (int i = 0; i < sounds.length; i++) {
      sounds[i]['chek'] = false;
    }
    setState(() {});
  }

  void _pickAll() {
    for (int i = 0; i < sounds.length; i++) {
      sounds[i]['chek'] = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      child: widget.edit
                          ? _EditPopupMenu(
                              cancelAll: () => _cancelAll(),
                              pickAll: () => _pickAll(),
                            )
                          : _PopupMenu(
                              sounds: sounds,
                              clearList: () {
                                Future.delayed(
                                    const Duration(
                                      milliseconds: 1000,
                                    ), () {
                                  setState(() {
                                    sounds = [];
                                  });
                                });
                              },
                            ),
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
                        rees: () => _rees(),
                        delete: () => _delete(),
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
                child: _DeletedStream(
                  create: _create,
                  child: _SoundsList(
                    sounds: sounds,
                    routName: widget.edit
                        ? EditDeletedPage.routName
                        : RecentlyDeletedPage.routName,
                    onDelete: (i) {
                      setState(() {
                        sounds.removeAt(i);
                      });
                    },
                    isEdit: widget.edit,
                    onChek: (i) {
                      setState(() {
                        sounds[i]['chek'] = !sounds[i]['chek'];
                      });
                    },
                    autoDeleted: _autoDelete,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _autoDelete(
    Map<String, dynamic> sound,
  ) {
    final DateTime now = DateTime.now();
    final DateTime timeDeleted = sound['dateDeleted'].toDate();

    if (now.difference(timeDeleted).inDays >= 15) {
      Database.deleteSound(
        sound['path'],
        sound['title'],
        sound['date'].toString(),
        sound['memory'],
      );
    }
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    required this.sounds,
    required this.clearList,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function() clearList;

  Future<void> _pickFew(BuildContext context) async {
    final dynamic result = await MyApp.firstKey.currentState!.pushNamed(
      EditDeletedPage.routName,
    );

    if (result.toString() == 'back') {
      clearList();
    }
  }

  void _deleteAll() {
    for (int i = sounds.length - 1; i >= 0; i = i - 1) {
      Database.deleteSound(
        sounds[i]['id'],
        sounds[i]['title'],
        sounds[i]['date'].toString(),
        sounds[i]['memory'],
      );
    }
    clearList();
  }

  void _reesAll() {
    for (int i = sounds.length - 1; i >= 0; i = i - 1) {
      Database.createOrUpdateSound(
        {
          'deleted': false,
          'id': sounds[i]['id'],
        },
      );
    }
    clearList();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) _pickFew(context);
        if (value == 1) _deleteAll();
        if (value == 2) _reesAll();
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
        PopupMenuItem(
          value: 1,
          child: Text(
            'Удалить все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Восстановить все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 60.0,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}

class _EditPopupMenu extends StatelessWidget {
  const _EditPopupMenu({
    Key? key,
    required this.cancelAll,
    required this.pickAll,
  }) : super(key: key);

  final void Function() cancelAll;
  final void Function() pickAll;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      onSelected: (value) {
        if (value == 0) pickAll();
        if (value == 1) cancelAll();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 0,
          child: const Text(
            'Выбрать все',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: const Text(
            'Сбросить выбор',
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
}

class _DeletedStream extends StatelessWidget {
  const _DeletedStream({
    Key? key,
    required this.child,
    this.create,
  }) : super(key: key);

  final void Function(AsyncSnapshot)? create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(LocalDB.uid)
          .collection('sounds')
          .where('deleted', isEqualTo: true)
          .orderBy(
            'date',
            descending: true, //was false
          )
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.hasData) {
          if (create != null) create!(snapshot);
          return child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _SoundsList extends StatefulWidget {
  const _SoundsList({
    Key? key,
    required this.sounds,
    required this.routName,
    required this.onDelete,
    required this.isEdit,
    required this.onChek,
    required this.autoDeleted,
  }) : super(key: key);

  final List<Map<String, dynamic>> sounds;
  final void Function(int) onDelete;
  final void Function(int) onChek;
  final void Function(Map<String, dynamic>) autoDeleted;
  final String routName;
  final bool isEdit;

  @override
  State<_SoundsList> createState() => _SoundsListState();
}

class _SoundsListState extends State<_SoundsList> {
  Widget? _player;
  double _bottom = 10.0;
  double _bottomEdit = 80.0;
  bool isPlay = false;

  void _play(int index) {
    if (!widget.sounds[index]['current']) {
      for (int i = 0; i < widget.sounds.length; i++) {
        widget.sounds[i]['current'] = false;
      }
      setState(() {
        _player = null;
        _bottom = 90.0;
        _bottomEdit = 160;
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
        _bottomEdit = 80.0;
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
          padding: EdgeInsets.only(
            top: 60.0,
            bottom: widget.isEdit ? _bottomEdit : _bottom,
            left: 20.0,
            right: 20.0,
          ),
          child: widget.sounds.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    top: 200.0,
                    left: 27.0,
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
                )
              : GroupedListView<dynamic, String>(
                  elements: widget.sounds,
                  groupBy: (element) => element['dateDeleted']
                      .toDate()
                      .toString()
                      .substring(0, 10),
                  groupComparator: (value1, value2) => value1.compareTo(
                    value2,
                  ),
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
                    Color color = widget.sounds[index]['current']
                        ? const Color(0xffF1B488)
                        : AppColor.active;

                    widget.autoDeleted(widget.sounds[index]);

                    return Column(
                      children: [
                        const SizedBox(
                          height: 4.0,
                        ),
                        SoundContainer(
                          color: color,
                          title: widget.sounds[index]['title'],
                          time: (widget.sounds[index]['time'] / 60)
                              .toStringAsFixed(1),
                          buttonRight: Align(
                            alignment: const AlignmentDirectional(0.9, -1.0),
                            child: widget.isEdit
                                ? CustomCheckBox(
                                    value: widget.sounds[index]['chek'],
                                    onTap: () => widget.onChek(index),
                                    color: Colors.black,
                                  )
                                : _DeleteButton(
                                    sound: widget.sounds[index],
                                    onDelete: () {
                                      _stop();
                                      widget.onDelete(index);
                                    },
                                  ),
                          ),
                          onTap: () {
                            _play(index);
                          },
                        ),
                        const SizedBox(height: 4.0),
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

  String _convertDate(String date) {
    final String result = date.substring(8, 10) +
        '.' +
        date.substring(5, 7) +
        '.' +
        date.substring(2, 4);
    return result;
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    Key? key,
    required this.sound,
    required this.onDelete,
  }) : super(key: key);
  final Map<String, dynamic> sound;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.95, 0.0),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Database.deleteSound(
            sound['id'],
            sound['title'],
            sound['date'].toString(),
            sound['memory'],
          );
          onDelete();
        },
        icon: Image.asset(
          AppIcons.delete,
          color: Colors.black,
        ),
        iconSize: 20.0,
      ),
    );
  }
}
