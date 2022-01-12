import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/welcome_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static const routName = '/';

  final int duration;

  const SplashPage({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: duration),
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();

        // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        // User? user;
        //
        // void getCurrentUser() async {
        //   User? _user = _firebaseAuth.currentUser;
        //   user = _user;
        // }
        //
        // getCurrentUser();

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) {
              // if (user != null) {
              //   return const MainPage();
              // } else {
                return const WelcomePage();
              // }
            },
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      },
    );

    return const Material(
      child: Background(
        height: 100.0,
        image: AppIcons.gradient,
        child: Center(
          child: Text(
            'Memory Box',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 36.0,
            ),
          ),
        ),
      ),
    );
  }
}
