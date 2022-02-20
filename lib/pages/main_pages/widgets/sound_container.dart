import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class SoundContainer extends StatelessWidget {
  String title;
  String time;

  SoundContainer({
    Key? key,
    required this.title,
    required this.time,
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
              colorFilter: const ColorFilter.mode(
                AppColor.active,
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
          const Spacer(),
          Align(
            alignment: const AlignmentDirectional(0.0, -2.5),
            child: TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
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
