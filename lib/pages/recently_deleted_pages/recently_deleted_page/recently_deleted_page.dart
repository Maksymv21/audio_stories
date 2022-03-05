import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../main_pages/widgets/button_menu.dart';
import '../../main_pages/widgets/sound_container.dart';

class RecentlyDeletedPage extends StatelessWidget {
  static const routName = '/deleted';

  const RecentlyDeletedPage({Key? key}) : super(key: key);

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
                image: AppIcons.upSearch,
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(-1.1, -0.95),
                      child: ButtonMenu(),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.12, -1.15),
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
                padding: EdgeInsets.all(30.0),
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(LocalDB.uid)
                        .collection('sounds')
                        .where('deleted', isEqualTo: true)
                        .orderBy('date', descending: false)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data?.docs.length == 0) {
                        return const Padding(
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
                      }
                      if (snapshot.hasData) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 100.0, bottom: 10.0),
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              String path = snapshot.data.docs[index].id;
                              String title = snapshot.data.docs[index]['title'];
                              String date =
                                  snapshot.data.docs[index]['date'].toString();

                              autoDelete(
                                snapshot.data.docs[index]['dateDeleted'],
                                path,
                                title,
                                date,
                              );
                              return Column(
                                children: [
                                  SoundContainer(
                                    color: const Color(0xff678BD2),
                                    title: title,
                                    time:
                                        (snapshot.data.docs[index]['time'] / 60)
                                            .toStringAsFixed(1),
                                    buttonRight: Align(
                                      alignment:
                                          const AlignmentDirectional(0.95, 0.0),
                                      child: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          Database.deleteSound(
                                            path,
                                            title,
                                            date,
                                          );
                                        },
                                        icon: Image.asset(
                                          AppIcons.delete,
                                          color: Colors.black,
                                        ),
                                        iconSize: 20.0,
                                      ),
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
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void autoDelete(
    Timestamp timestamp,
    String path,
    String title,
    String date,
  ) {
    final DateTime now = DateTime.now();
    final DateTime timeDeleted = timestamp.toDate();

    if (now.difference(timeDeleted).inDays >= 15) {
      Database.deleteSound(
        path,
        title,
        date,
      );
    }
  }
}
