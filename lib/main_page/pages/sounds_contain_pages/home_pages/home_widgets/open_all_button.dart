
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../../main_page.dart';
import '../../audio_page/audio_page/audio_page.dart';

class OpenAllButton extends StatelessWidget {
  final Color color;

  const OpenAllButton({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocIndex(0),
      child: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () {
          MainPage.globalKey.currentState!
              .pushReplacementNamed(AudioPage.routName);
          context.read<BlocIndex>().add(
            ColorAudio(),
          );
        },
        child: Text(
          'Открыть все',
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }
}
