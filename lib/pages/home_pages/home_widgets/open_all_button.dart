import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/color_icon_bloc/color_icon_bloc.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenAllButton extends StatelessWidget {
  final Color color;

  const OpenAllButton({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorBloc(
        [
          AppColor.active,
          AppColor.disActive,
          AppColor.disActive,
          AppColor.disActive,
        ],
      ),
      child: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () {
          Utils.globalKey.currentState!
              .pushReplacementNamed(AudioPage.routName);
          context.read<ColorBloc>().add(
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
