import 'package:audio_stories/bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_page.dart';
import 'package:audio_stories/pages/glad_to_see_page.dart';
import 'package:audio_stories/pages/welcome_page.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/splash_page.dart';
import 'package:audio_stories/provider/auth_provider.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
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
          phoneAuthFirebaseProvider: PhoneAuthFirebaseProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
      ),
      child: MaterialApp(
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
          GladPage.routName: (context) => const GladPage(),
        },
      ),
    );
  }
}
