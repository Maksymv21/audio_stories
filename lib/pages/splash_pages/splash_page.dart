import 'dart:async';

import 'package:audio_stories/pages/welcome_pages/welcome_page.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'splash_glad_page.dart';

class SplashPage extends StatefulWidget {
  static const routName = '/';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    Timer(
      const Duration(milliseconds: 3000),
      () {
        User? _user = _firebaseAuth.currentUser;
        if (_user != null) {
          return _navigateToPage(const SplashGladPage());
        } else {
          return _navigateToPage(const WelcomePage());
        }
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return page;
        },
        transitionDuration: const Duration(seconds: 0),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Background(
        height: 100.0,
        image: AppImages.gradient,
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
