import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile'),
    );
  }
}