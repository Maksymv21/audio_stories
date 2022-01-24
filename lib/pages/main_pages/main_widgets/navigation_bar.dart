import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/color_icon_bloc/color_icon_bloc.dart';
import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/category_pages/category_page/category_page.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/foot_button.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({
    Key? key,
  }) : super(key: key);

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
      child: BlocBuilder<ColorBloc, List<Color>>(
        builder: (context, color) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FootButton(
              icon: AppIcons.home,
              title: 'Главная',
              color: color[0],
              onPressed: () {
                Utils.globalKey.currentState!
                    .pushReplacementNamed(MainPage.routName);
                context.read<ColorBloc>().add(
                      ColorHome(),
                    );
              },
            ),
            FootButton(
              icon: AppIcons.category,
              title: 'Подборки',
              color: color[1],
              onPressed: () {
                Utils.globalKey.currentState!
                    .pushReplacementNamed(CategoryPage.routName);
                context.read<ColorBloc>().add(
                      ColorCategory(),
                    );
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
              color: color[2],
              onPressed: () {
                Utils.globalKey.currentState!
                    .pushReplacementNamed(AudioPage.routName);
                context.read<ColorBloc>().add(
                      ColorAudio(),
                    );
              },
            ),
            FootButton(
              icon: AppIcons.profile,
              title: 'Профиль',
              color: color[3],
              onPressed: () {
                User? _user = FirebaseAuth.instance.currentUser;
                if (_user != null) {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(ProfilePage.routName);
                  context.read<ColorBloc>().add(
                        ColorProfile(),
                      );
                } else {
                  Utils.firstKey.currentState!
                      .pushReplacementNamed(AuthPage.routName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
