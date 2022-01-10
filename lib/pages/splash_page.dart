import 'package:audio_stories/pages/welcome_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
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
        // await for the Firebase initialization to occur
        // FirebaseApp app = await Firebase.initializeApp();

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomePage(),
            transitionDuration:const Duration(seconds: 0),
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
