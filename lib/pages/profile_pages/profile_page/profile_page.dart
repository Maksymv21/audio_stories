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
      child: TextButton(
        onPressed: () async {
          User? user = _firebaseAuth.currentUser;
          print(user);
          await user?.delete();
          Utils.firstKey.currentState!.pushReplacementNamed(WelcomePage.routName);
        },
        child: const Text('delete user'),
      ),
    );
  }
}
