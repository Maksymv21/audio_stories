import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/database.dart';
import '../../../utils/local_db.dart';
import '../../../widgets/dialog_sound.dart';
import '../../main_pages/widgets/button_menu.dart';
import '../../main_pages/widgets/sound_container.dart';

class AudioPage extends StatelessWidget {
  static const routName = '/audio';

  const AudioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(LocalDB.uid)
            .collection('sounds')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
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
                  padding: const EdgeInsets.only(top: 225.0, bottom: 10.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final String title = snapshot.data.docs[index]['title'];
                      final String id = snapshot.data.docs[index].id;
                      return Column(
                        children: [
                          SoundContainer(
                            color: const Color(0xff678BD2),
                            title: title,
                            time: (snapshot.data.docs[index]['time'] / 60)
                                .toStringAsFixed(1),
                            delete: () {
                              Database.deleteSound(id);
                            },
                            name: () => _dialog(
                              context,
                              title,
                              id,
                            ),
                          ),
                          const SizedBox(
                            height: 7.0,
                          ),
                        ],
                      );
                    },
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

  Future<String?> _dialog(
    BuildContext context,
    String title,
    String id,
  ) {
    final TextEditingController controller = TextEditingController();
    controller.text = title;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => DialogSound(
        content: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        title: 'Введите новое название',
        onPressedCancel: () => Navigator.pop(context, 'Cancel'),
        onPressedSave: () {
          if (controller.text != '') {
            Database.createOrUpdateSound({'title': controller.text}, id: id);
          }
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }
}
