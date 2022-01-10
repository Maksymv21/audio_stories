import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/button_menu.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Background(
          image: AppIcons.upSearch,
          height: 275.0,
          child: Stack(
            children: [
              const Align(
                alignment: AlignmentDirectional(-1.1, -0.55),
                child: ButtonMenu(),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, -0.53),
                child: Text(
                  'Поиск',
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
                alignment: AlignmentDirectional(0.0, -0.2),
                child: Text(
                  'Найди потеряшку',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
