import 'dart:async';

import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/welcome_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main_page/main_page.dart';

class SplashGladPage extends StatefulWidget {
  static const routName = '/glad';

  const SplashGladPage({Key? key}) : super(key: key);

  @override
  State<SplashGladPage> createState() => _SplashGladPageState();
}

class _SplashGladPageState extends State<SplashGladPage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    Timer(
      const Duration(milliseconds: 3000),
      () {
        LocalDB.uid = _user?.uid;
        LocalDB.phoneNumber = _user?.phoneNumber;
        LocalDB.refactorNumber();

        return _navigateToPage();
      },
    );
  }

  void _navigateToPage() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return const MainPage();
        },
        transitionDuration: const Duration(seconds: 0),
      ),
      (_) => false,
    );
  }

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
                margin: const EdgeInsets.all(10.0),
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
          const Spacer(),
          const Expanded(
            flex: 2,
            child: WelcomeContainer(
              text: 'Мы рады тебя видеть',
              width: 305.0,
              fontSize: 24.0,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 2,
            child: Image(
              image: Image.asset(AppIcons.heart).image,
            ),
          ),
          const Spacer(
            flex: 3,
          ),
          const Expanded(
            flex: 3,
            child: WelcomeContainer(
              text: 'Взрослые иногда нуждаются в'
                  '\nсказке даже больше, чем дети',
              width: 280.0,
              fontSize: 16.0,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
