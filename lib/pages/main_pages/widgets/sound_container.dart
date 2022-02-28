import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class SoundContainer extends StatelessWidget {
  String title;
  String time;
  Color color;
  void Function()? delete;
  void Function()? name;
  void Function()? download;

  SoundContainer({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
    this.delete,
    this.name,
    this.download,
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
                      Radius.circular(15.0),
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
                  onTap: name,
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
                  onTap: download,
                ),
                PopupMenuItem(
                  child: const Text(
                    'Удалить',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: delete,
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
}
