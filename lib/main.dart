import 'package:audio_stories/Pages/welcome_page.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/registration_page.dart';
import 'package:audio_stories/resources/utils.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/registration': (context) => const RegistrationPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}


