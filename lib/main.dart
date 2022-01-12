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
      initialRoute: SplashPage.routName,
      routes: {
        SplashPage.routName: (context) => const SplashPage(
              duration: 4,
            ),
        WelcomePage.routName: (context) => const WelcomePage(),
        RegistrationPage.routName: (context) => RegistrationPage(),
        MainPage.routName: (context) => const MainPage(),
        RegistrationSMSPage.routName: (context) => const RegistrationSMSPage(),
      },
    );
  }
}
