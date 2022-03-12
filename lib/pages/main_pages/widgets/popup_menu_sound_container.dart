import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/database.dart';
import '../../../widgets/dialog_sound.dart';

//ignore: must_be_immutable
class PopupMenuSoundContainer extends StatelessWidget {
  String url;
  String id;
  String title;
  double size;
  void Function()? pop;
  void Function()? edit;

  PopupMenuSoundContainer({
    Key? key,
    required this.url,
    required this.id,
    required this.title,
    required this.size,
    this.pop,
    this.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(),
        const CircleBorder(),
        0.2,
      ),
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
            onTap: () {
              _dialog(context, title, id);
              edit;
            }),
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
            pop;
            Database.createOrUpdateSound(
              {
                'deleted': true,
                'dateDeleted': Timestamp.now(),
              },
              id: id,
            );
          },
        ),
      ],
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.black,
          fontSize: size,
          letterSpacing: 1.0,
        ),
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
    );
  }
}
