import 'dart:async';

import 'package:audio_stories/main_page/main_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../splash_glad_page/splash_glad_page.dart';

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
        }

        return _navigateToPage(const MainPage());
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
