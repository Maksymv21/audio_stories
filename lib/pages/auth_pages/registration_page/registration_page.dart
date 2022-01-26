import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/continue_button.dart';
import 'package:audio_stories/widgets/number_form.dart';
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
          Expanded(
            flex: 2,
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
              hintText: hintText,
            ),
          ),
          const Spacer(
            flex: 4,
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
          const Expanded(
            flex: 5,
            child: WelcomeContainer(
              text: 'Регистрация привяжет твои сказки'
                  '\nк облаку, после чего они всегда '
                  '\nбудут с тобой',
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
