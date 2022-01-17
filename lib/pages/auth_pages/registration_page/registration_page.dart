import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/continue_button.dart';
import 'package:audio_stories/pages/auth_pages/auth_widgets/number_form.dart';
import 'package:audio_stories/widgets/welcome_container.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  final String text;
  final String hintText;
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
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Background(
            height: 300.0,
            image: AppIcons.up,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Регистрация',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 48.0,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: 'TTNormsL',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          NumberForm(
            controller: controller,
            hintText: hintText,
          ),
          const SizedBox(
            height: 80.0,
          ),
          ContinueButton(
            onPressed: onPressed,
          ),
          SizedBox(
            height: height,
          ),
          widget,
          const WelcomeContainer(
            text: 'Регистрация привяжет твои сказки'
                '\nк облаку, после чего они всегда '
                '\nбудут с тобой',
            width: 280.0,
            height: 110.0,
            fontSize: 16.0,
          ),
        ],
      ),
    );
  }
}
