import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_glad_page/splash_glad_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_page/splash_page.dart';
import 'package:audio_stories/pages/auth_pages/auth_repository/auth_repository.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthBloc(
        phoneAuthRepository: PhoneAuthRepository(
          firebaseAuth: FirebaseAuth.instance,
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'TTNorms',
        ),
        navigatorKey: Utils.firstKey,
        initialRoute: SplashPage.routName,
        routes: {
          SplashPage.routName: (context) => SplashPage(
                duration: 4,
              ),
          WelcomePage.routName: (context) => const WelcomePage(),
          AuthPage.routName: (context) => AuthPage(),
          MainPage.routName: (context) => const MainPage(),
          SplashGladPage.routName: (context) => SplashGladPage(),
        },
      ),
    );
  }
}
