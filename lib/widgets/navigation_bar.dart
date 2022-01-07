import 'package:audio_stories/resources/app_colors.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/widgets/foot_button.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class MyNavigationBar extends StatefulWidget {

  const MyNavigationBar({Key? key,}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  final ColorActive _colorIcon = ColorActive();


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
          FootButton(
            icon: AppIcons.home,
            title: 'Главная',
            color: _colorIcon.colorHome,
            onPressed: () {
              setState(() {
                Utils.globalKey.currentState!.pushReplacementNamed('/');
                _colorIcon.homeActive();
              });

            },
          ),
          FootButton(
            icon: AppIcons.category,
            title: 'Подборки',
            color: _colorIcon.colorCategory,
            onPressed: () {
              setState(() {
                Utils.globalKey.currentState!.pushReplacementNamed('/category');
                _colorIcon.categoryActive();
              });
            },
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
          FootButton(
            icon: AppIcons.paper,
            title: 'Ауидозаписи',
            color: _colorIcon.colorAudio,
            onPressed: () {
              setState(() {
                Utils.globalKey.currentState!.pushReplacementNamed('/paper');
                _colorIcon.audioActive();
              });
            },
          ),
          FootButton(
            icon: AppIcons.profile,
            title: 'Профиль',
            color: _colorIcon.colorProfile,
            onPressed: () {
              setState(() {
                Utils.globalKey.currentState!.pushReplacementNamed('/profile');
                _colorIcon.profileActive();
              });
            },
          ),
        ],
      ),
    );
  }
}
