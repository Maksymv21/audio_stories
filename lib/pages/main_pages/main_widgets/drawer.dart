import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/category_pages/category_page/category_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/pages/search_pages/search_page/search_page.dart';
import 'package:audio_stories/pages/subscription_pages/subscription_page/subscription_page.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/burger_button.dart';
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
          const Spacer(
            flex: 3,
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Аудиосказки',
              style: TextStyle(
                fontSize: 26.0,
              ),
            ),
          ),
          const Spacer(),
          const Expanded(
            flex: 2,
            child: Text(
              'Меню',
              style: TextStyle(
                fontSize: 22.0,
                color: Color.fromRGBO(58, 58, 85, 0.5),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 13,
            child: Column(
              children: [
                BurgerButton(
                  icon: AppIcons.home,
                  title: 'Главная',
                  onTap: () {
                    Utils.globalKey.currentState!
                        .pushReplacementNamed(MainPage.routName);
                    Scaffold.of(context).openEndDrawer();
                    context.read<BlocIndex>().add(
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
                    context.read<BlocIndex>().add(
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
                    context.read<BlocIndex>().add(
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
                    context.read<BlocIndex>().add(
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
                    context.read<BlocIndex>().add(
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
                    context.read<BlocIndex>().add(
                          NoColor(),
                        );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: BurgerButton(
              icon: AppIcons.wallet,
              title: 'Подписка',
              onTap: () {
                Utils.globalKey.currentState!
                    .pushReplacementNamed(SubscriptionPage.routName);
                Scaffold.of(context).openEndDrawer();
                context.read<BlocIndex>().add(
                      NoColor(),
                    );
              },
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: BurgerButton(
              icon: AppIcons.edit,
              title: 'Написать в '
                  '\nподдержку',
              onTap: () {},
            ),
          ),
          const Spacer(
            flex: 4,
          ),
        ],
      ),
    );
  }
}
