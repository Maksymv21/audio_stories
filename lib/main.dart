import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_pages/auth_page.dart';
import 'package:audio_stories/pages/auth_pages/auth_repository/auth_repository.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/sounds_contain_pages/recently_deleted_pages/edit_deleted_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_glad_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('en_GB');
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> firstKey = GlobalKey();

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
        navigatorKey: firstKey,
        initialRoute: SplashPage.routName,
        routes: {
          SplashPage.routName: (context) => const SplashPage(),
          WelcomePage.routName: (context) => const WelcomePage(),
          AuthPage.routName: (context) => const AuthPage(),
          MainPage.routName: (context) => const MainPage(),
          SplashGladPage.routName: (context) => const SplashGladPage(),
          EditDeletedPage.routName: (context) => const EditDeletedPage(),
        },
      ),
    );
  }
}
