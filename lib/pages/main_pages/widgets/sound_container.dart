import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class SoundContainer extends StatelessWidget {
  String title;
  String time;
  Color color;

  SoundContainer({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
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
      child: Row(
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
          const Spacer(
            flex: 2,
          ),
          Expanded(
            child: Align(
              alignment: const AlignmentDirectional(0.0, -1.0),
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
                    onTap: () {},
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
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const Text(
                      'Удалить',
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
                    color: Colors.black,
                    fontSize: 30.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
