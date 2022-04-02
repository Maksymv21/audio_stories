import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class SoundContainer extends StatelessWidget {
  SoundContainer({
    Key? key,
    required this.title,
    required this.time,
    required this.color,
    required this.buttonRight,
    this.onTap,
  }) : super(key: key);

  String title;
  String time;
  Color color;
  Widget buttonRight;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.91,
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
                child: GestureDetector(
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
                  onTap: onTap,
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
          buttonRight,
        ],
      ),
    );
  }
}
