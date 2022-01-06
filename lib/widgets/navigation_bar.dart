import 'package:audio_stories/Widgets/foot_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const FootButton(
            icon: AppIcons.home,
            title: 'Главная',
          ),
          const FootButton(
            icon: AppIcons.category,
            title: 'Подборки',
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 53.0,
              height: 57.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppIcons.record,
                  ),
                ),
              ),
            ),
          ),
          const FootButton(
            icon: AppIcons.paper,
            title: 'Ауидозаписи',
          ),
          const FootButton(
            icon: AppIcons.profile,
            title: 'Профиль',
          ),
        ],
      ),
    );
  }
}
