import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/button_menu.dart';
import 'package:flutter/material.dart';

class AudioPage extends StatelessWidget {
  static const routName = '/audio';

  const AudioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Background(
          image: AppIcons.upBlue,
          height: 275.0,
          child: Stack(
            children: [
              const Align(
                alignment: AlignmentDirectional(-1.1, -0.55),
                child: ButtonMenu(),
              ),
              const Align(
                alignment: AlignmentDirectional(0.1, -0.53),
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
                alignment: const AlignmentDirectional(1.12, -0.725),
                child: TextButton(
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {},
                  child: const Text(
                    '...',
                    style: TextStyle(
                        color: Colors.white, fontSize: 48, letterSpacing: 3.0),
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.05, -0.2),
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
              const Align(
                alignment: AlignmentDirectional(-1.0, 0.4),
                child: Text(
                  '0 аудио'
                      '\n0 часов',
                  style: TextStyle(
                    fontFamily: 'TTNormsL',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.0, 0.475),
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
                alignment: const AlignmentDirectional(0.5, 0.475),
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
            ],
          ),
        ),
      ],
    );
  }
}
