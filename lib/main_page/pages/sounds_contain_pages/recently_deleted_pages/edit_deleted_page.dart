import 'package:flutter/material.dart';

import 'general_deleted_page.dart';

class EditDeletedPage extends StatelessWidget {
  static const routName = '/editDeleted';

  const EditDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GeneralDeletedPage(
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
      ),
    );
  }
}
