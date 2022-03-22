import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/compilation_pages/pick_few_compilation_page/pick_few_compilation_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/edit_deleted_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_glad_page/splash_glad_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/splash_pages/splash_page/splash_page.dart';
import 'package:audio_stories/pages/auth_pages/auth_repository/auth_repository.dart';
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
          SplashPage.routName: (context) => SplashPage(
                duration: 4,
              ),
          WelcomePage.routName: (context) => const WelcomePage(),
          AuthPage.routName: (context) => AuthPage(),
          MainPage.routName: (context) => const MainPage(),
          SplashGladPage.routName: (context) => SplashGladPage(),
          EditDeletedPage.routName: (context) => const EditDeletedPage(),
        },
      ),
    );
  }
}
