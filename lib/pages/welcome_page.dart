import 'package:audio_stories/pages/registration_page.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/continue_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  static const routName = '/welcome';

  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Background(
            height: 300.0,
            image: AppIcons.up,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(31.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'MemoryBox',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 48.0,
                        letterSpacing: 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Твой голос всегда рядом',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text(
            'Привет!',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            'Мы рады видеть тебя здесь.'
            '\nЭто приложение поможет записывать '
            '\nсказки и держать их в удобном месте не '
            '\nзаполняя память на телефоне',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'TTNormsL',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 45.0,
          ),
          ContinueButton(
            onPressed: () {
              Utils.firstKey.currentState!.pushNamedAndRemoveUntil(
                RegistrationPage.routName,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
