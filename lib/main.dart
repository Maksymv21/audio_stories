import 'package:audio_stories/pages/welcome_page.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/registration_page.dart';
import 'package:audio_stories/pages/registration_sms.dart';
import 'package:audio_stories/pages/splash_page.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'TTNorms',
      ),
      navigatorKey: Utils.firstKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(
              duration: 3,
            ),
        '/welcome': (context) => const WelcomePage(),
        '/registration': (context) => const RegistrationPage(),
        '/main': (context) => const MainPage(),
        '/sms': (context) => const RegistrationSMSPage(),
      },
    );
  }
}
