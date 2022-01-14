import 'package:audio_stories/pages/glad_to_see_page.dart';
import 'package:audio_stories/pages/welcome_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static const routName = '/';

  final int duration;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SplashPage({
    Key? key,
    required this.duration,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: duration),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) {
              User? _user = _firebaseAuth.currentUser;
              print(_user);
              if (_user != null) {
                return const GladPage();
              } else {
                return const WelcomePage();
              }
            },
            transitionDuration: const Duration(seconds: 0),
          ),
          (Route<dynamic> route) => false,
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
