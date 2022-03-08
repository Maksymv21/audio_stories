import 'package:flutter/material.dart';

import '../../../resources/app_icons.dart';

class TestPage extends StatefulWidget {
  static const routName = '/test';

  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Image.asset(AppIcons.arrow), label: ''),
          BottomNavigationBarItem(icon: Image.asset(AppIcons.arrow), label: ''),
        ],
      ),
    );
  }
}
