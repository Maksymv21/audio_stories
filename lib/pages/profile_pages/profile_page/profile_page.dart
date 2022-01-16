import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routName = '/profile';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              User? user = _firebaseAuth.currentUser;
              print(user);
              await user?.delete();
              Utils.firstKey.currentState!
                  .pushReplacementNamed(WelcomePage.routName);
            },
            child: const Text('delete user'),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              Utils.firstKey.currentState!
                  .pushReplacementNamed(AuthPage.routName);
            },
            child: const Text('authorization'),
          ),
        ],
      ),
    );
  }
}
