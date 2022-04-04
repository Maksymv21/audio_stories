import 'package:audio_stories/main_page/main_page.dart';
import 'package:audio_stories/main_page/pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/custom_will_pop_scope.dart';
import 'general_deleted_page.dart';

class EditDeletedPage extends StatelessWidget {
  static const routName = '/editDeleted';

  const EditDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomWillPopScope(
      child: Scaffold(
        body: GeneralDeletedPage(
          button: Align(
            alignment: const AlignmentDirectional(1.05, 0.5),
            child: TextButton(
              onPressed: () {
                // MainPage.globalKey.currentState!.pushReplacementNamed(
                //   RecentlyDeletedPage.routName,
                // );
                Navigator.pop(context, 'back');
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
        ),
      ),
    );
  }
}
