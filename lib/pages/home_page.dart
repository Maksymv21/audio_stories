import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/button_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Background(
          height: 375.0,
          image: AppIcons.up,
          child: Stack(
            children: [
              const Align(
                alignment: AlignmentDirectional(-1.1, -0.7),
                child: ButtonMenu(),
              ),
              const Align(
                alignment: AlignmentDirectional(-1.0, -0.3),
                child: Text(
                  'Подборки',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.1, -0.3),
                child: TextButton(
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Открыть все',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-1.0, 2.1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(113, 165, 159, 0.75),
                  ),
                  width: 183.0,
                  height: 240.0,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      const Text(
                        'Здесь будет'
                        '\nтвой набор '
                        '\nсказок',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Добавить',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.0, 0.4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(241, 180, 136, 1.0),
                  ),
                  width: 160.0,
                  height: 112.0,
                  child: const Center(
                    child: Text(
                      'Тут',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.0, 1.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(103, 139, 210, 0.75),
                  ),
                  width: 160.0,
                  height: 112.0,
                  //color: const Color.fromRGBO(113, 165, 159, 0.75),
                  child: const Center(
                    child: Text(
                      'И тут',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
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
