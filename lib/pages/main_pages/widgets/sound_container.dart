import 'package:audio_stories/resources/app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/database.dart';
import '../../../widgets/dialog_sound.dart';

class SoundContainer extends StatelessWidget {
  String title;
  String time;
  String url;
  Timestamp date;
  Color color;
  String id;

  SoundContainer({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
    required this.id,
    required this.date,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.0,
      height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(41.0),
        border: Border.all(
          color: Colors.grey[400]!,
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                ),
                child: ColorFiltered(
                  child: Image.asset(
                    AppIcons.playRecord,
                    width: 50.0,
                    height: 50.0,
                  ),
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcATop,
                  ),
                ),
              ),
              const SizedBox(
                width: 25.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '$time минут',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: const AlignmentDirectional(0.9, -1.0),
            child: PopupMenuButton(
              shape: ShapeBorder.lerp(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.0),
                    ),
                  ),
                  const CircleBorder(),
                  0.3),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Добавить в подборку',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Редактировать название',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () => _dialog(context, title, id),
                ),
                PopupMenuItem(
                  child: const Text(
                    'Поделиться',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Скачать',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    download2(url, title).then(
                      (value) => _showSnackBar(
                        context: context,
                        title: 'Файл сохранен.'
                            '\nDownload/$title.aac',
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text(
                    'Удалить',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    Database.deleteSound(
                    id,
                    title,
                    date.toString(),
                  );
               }
                ),
              ],
              child: const Text(
                '...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  void _showSnackBar({
    required BuildContext context,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future download2(String url, String name) async {
    String path = 'storage/emulated/0/Download/$name.aac';

    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    print("${dir.path}/$name.aac");

    await dio.download(
      url,
      path,
      // "${dir.path}/$name.aac",
      //"sdcard/Download/$name.aac",
    );
  }
}
