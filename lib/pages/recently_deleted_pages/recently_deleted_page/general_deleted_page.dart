import 'package:audio_stories/pages/main_pages/widgets/custom_checkbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/background.dart';
import '../../main_pages/widgets/sound_container.dart';
import 'edit_deleted_page.dart';

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
          _popup = widget.edit
              ? _popupEditMenu()
              : _popupMenu(snapshot, snapshot.data.docs.length);
        } else {
          _popup = const Center(
            child: CircularProgressIndicator(),
          );
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
                const Spacer(
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
          ],
        );
      },
    );
  }

  Widget _soundList(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Padding(
        padding: const EdgeInsets.only(top: 85.0, bottom: 10.0),
        child: ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            String path = snapshot.data.docs[index].id;
            String title = snapshot.data.docs[index]['title'];
            String date = snapshot.data.docs[index]['date'].toString();
            int memory = snapshot.data.docs[index]['memory'];

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
                  color: const Color(0xff678BD2),
                  title: title,
                  time: (snapshot.data.docs[index]['time'] / 60)
                      .toStringAsFixed(1),
                  buttonRight: widget.edit
                      ? const CustomCheckBox()
                      : _deletedButton(
                          path,
                          title,
                          date,
                          memory,
                        ),
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
              MainEditDeletedPage.routName,
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
              final String id = snapshot.data.docs[i].id;
              Database.createOrUpdateSound(
                {
                  'deleted': false,
                },
                id: id,
              );
            }
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

  Widget _popupEditMenu() {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: const Text(
            'Удалить',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Text(
            'Восстановить',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onTap: () {},
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
