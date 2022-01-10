import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Background(
          image: AppIcons.upGreen,
          height: 325.0,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(-1.125, -0.625),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 40.0,
                  icon: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {},
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, -0.6),
                child: Text(
                  'Подборки',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 36.0,
                    letterSpacing: 3.0,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.12, -0.8),
                child: TextButton(
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {},
                  child: const Text(
                    '...',
                    style: TextStyle(
                        color: Colors.white, fontSize: 48, letterSpacing: 3.0),
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, -0.325),
                child: Text(
                  'Все в одном месте',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
