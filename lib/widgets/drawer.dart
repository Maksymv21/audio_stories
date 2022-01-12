import 'package:audio_stories/bloc/bloc_icon_color.dart';
import 'package:audio_stories/pages/audio_page.dart';
import 'package:audio_stories/pages/category_page.dart';
import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/pages/profile_page.dart';
import 'package:audio_stories/pages/recently_deleted_page.dart';
import 'package:audio_stories/pages/search_page.dart';
import 'package:audio_stories/pages/subscription_page.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/burger_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          const Text(
            'Аудиосказки',
            style: TextStyle(
              fontSize: 26.0,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            'Меню',
            style: TextStyle(
              fontSize: 22.0,
              color: Color.fromRGBO(58, 58, 85, 0.5),
            ),
          ),
          const SizedBox(
            height: 70.0,
          ),
          Column(
            children: [
              BurgerButton(
                icon: AppIcons.home,
                title: 'Главная',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(MainPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    ColorHome(),
                  );
                },
              ),
              BurgerButton(
                icon: AppIcons.profile,
                title: 'Профиль',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(ProfilePage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    ColorProfile(),
                  );
                },
              ),
              BurgerButton(
                icon: AppIcons.category,
                title: 'Подборки',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(CategoryPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    ColorCategory(),
                  );
                },
              ),
              BurgerButton(
                icon: AppIcons.paper,
                title: 'Все аудиофайлы',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(AudioPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    ColorAudio(),
                  );
                },
              ),
              BurgerButton(
                icon: AppIcons.search,
                title: 'Поиск',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(SearchPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    NoColor(),
                  );
                },
              ),
              BurgerButton(
                icon: AppIcons.delete,
                title: 'Недавно удаленные',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(RecentlyDeletedPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    NoColor(),
                  );
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.wallet,
                title: 'Подписка',
                onTap: () {
                  Utils.globalKey.currentState!
                      .pushReplacementNamed(SubscriptionPage.routName);
                  Scaffold.of(context).openEndDrawer();
                  context.read<ColorBloc>().add(
                    NoColor(),
                  );
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              BurgerButton(
                icon: AppIcons.edit,
                title: 'Написать в '
                    '\nподдержку',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
