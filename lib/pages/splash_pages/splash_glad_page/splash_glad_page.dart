import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/main_pages/models/model_user.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/welcome_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashGladPage extends StatelessWidget {
  static const routName = '/glad';

  SplashGladPage({Key? key}) : super(key: key);

  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () async {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            ModelUser.uid = _user?.uid;
            ModelUser.phoneNumber = _user?.phoneNumber;
            ModelUser.createUser();
            // ModelUser.readName();
            return const MainPage();
          },
          transitionDuration: const Duration(seconds: 0),
        ),
        (Route<dynamic> route) => false,
      );
    });

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
          const SizedBox(
            height: 40.0,
          ),
          const WelcomeContainer(
            text: 'Мы рады тебя видеть',
            width: 305.0,
            height: 80.0,
            fontSize: 24.0,
          ),
          const SizedBox(
            height: 59.0,
          ),
          Image(
            image: Image.asset(AppIcons.heart).image,
          ),
          const SizedBox(
            height: 110.0,
          ),
          const WelcomeContainer(
            text: 'Взрослые иногда нуждаются в'
                '\nсказке даже больше, чем дети',
            width: 280.0,
            height: 110.0,
            fontSize: 16.0,
          ),
        ],
      ),
    );
  }
}
