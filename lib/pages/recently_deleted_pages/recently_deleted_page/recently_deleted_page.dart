import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/general_deleted_page.dart';
import 'package:flutter/material.dart';

import '../../main_pages/widgets/button_menu.dart';

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

