import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/buttons/continue_button.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:audio_stories/widgets/uncategorized/number_form.dart';
import 'package:audio_stories/widgets/uncategorized/welcome_container.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  final String text;
  final Widget widget;
  final TextEditingController controller;
  final Function() onPressed;
  final double height;

  const RegistrationPage({
    Key? key,
    required this.widget,
    required this.text,
    required this.controller,
    required this.onPressed,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _text = RegistrationPageText.footerRegistration;
    if (RegistrationPageText.header == 'Авторизация') {
      _text = RegistrationPageText.footerAuth;
    }
    if (RegistrationPageText.header == 'Замена номера') {
      _text = RegistrationPageText.footerChange;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Background(
            height: 300.0,
            image: AppImages.up,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    RegistrationPageText.header,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 48.0,
                      letterSpacing: 3.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'TTNormsL',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: NumberForm(
              controller: controller,
            ),
          ),
          const Spacer(
            flex: 3,
          ),
          Expanded(
            flex: 3,
            child: ContinueButton(
              onPressed: onPressed,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: widget,
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: WelcomeContainer(
              text: _text,
              width: 280.0,
              fontSize: 16.0,
            ),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}

class RegistrationPageText {
  RegistrationPageText._();

  static String header = 'Регистрация';

  static String footerRegistration = 'Регистрация привяжет твои сказки'
      '\nк облаку, после чего они всегда '
      '\nбудут с тобой';
  static String footerAuth = 'Авторизация на некоторое время'
      '\nдаст тебе возможность'
      '\nудалить аккаунт';
  static String footerChange = 'Не волнуйся, все данные'
      '\nтвоего аккаунта будут сохранены'
      '\nпри замене номера';
}
