import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/general_deleted_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class MainEditDeletedPage extends StatelessWidget {
  static const routName = '/mainEditDeleted';

  const MainEditDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const EditDeletedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Image.asset(AppIcons.arrow), label: ''),
          BottomNavigationBarItem(icon: Image.asset(AppIcons.arrow), label: ''),
        ],
      ),
    );
  }
}

class EditDeletedPage extends StatelessWidget {
  static const routName = '/editDeleted';

  const EditDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralDeletedPage(
      button: Align(
        alignment: const AlignmentDirectional(1.05, 0.5),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Отменить',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      edit: true,
    );
  }
}
