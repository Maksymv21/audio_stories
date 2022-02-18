import 'package:audio_stories/pages/home_pages/home_widgets/open_all_button.dart';
import 'package:audio_stories/pages/main_pages/widgets/sound_container.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

import '../../main_pages/widgets/button_menu.dart';

class HomePage extends StatelessWidget {
  static const routName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget _soundList =
    return Stack(
      children: [
        Column(
          children: const [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppIcons.up,
                child: Align(
                  alignment: AlignmentDirectional(-1.1, -0.95),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Column(
          children: [
            const Spacer(
              flex: 4,
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  const Spacer(),
                  const Expanded(
                    flex: 11,
                    child: Text(
                      'Подборки',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 9,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: const [
                        Spacer(),
                        Expanded(
                          flex: 5,
                          child: OpenAllButton(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 12,
              child: Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromRGBO(113, 165, 159, 0.75),
                      ),
                      child: Column(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          const Expanded(
                            flex: 4,
                            child: Text(
                              'Здесь будет'
                              '\nтвой набор '
                              '\nсказок',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: TextButton(
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
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 12,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
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
                        const Spacer(),
                        Expanded(
                          flex: 7,
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
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(
              flex: 17,
            ),
          ],
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 1.05),
          child: Container(
            width: 380.0,
            height: MediaQuery.of(context).size.height * 0.38,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Stack(
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.9, -0.9),
                  child: Text(
                    'Аудиозаписи',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(1.0, -0.92),
                  child: OpenAllButton(
                    color: Colors.black,
                  ),
                ),
                Center(child: SoundContainer()),
                // const Align(
                //   alignment: AlignmentDirectional(0.0, -0.2),
                //   child: Text(
                //     'Как только ты запишешь'
                //     '\nаудио, она появится здесь.',
                //     style: TextStyle(
                //       fontSize: 20.0,
                //       color: Colors.grey,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Align(
                //   alignment: const AlignmentDirectional(-0.05, 0.7),
                //   child: Image(
                //     image: Image.asset(AppIcons.arrow).image,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
