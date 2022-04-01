import 'package:flutter/material.dart';

import '../../../../widgets/buttons/button_menu.dart';
import 'general_deleted_page.dart';




class RecentlyDeletedPage extends StatelessWidget {
  static const routName = '/deleted';

  const RecentlyDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralDeletedPage(
      button: const Align(
        alignment: AlignmentDirectional(-1.1, -0.92),
        child: ButtonMenu(),
      ),
      edit: false,
    );
  }
}

