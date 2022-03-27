import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/pages/search_pages/search_page/search_page.dart';
import 'package:audio_stories/pages/subscription_pages/subscription_page/subscription_page.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../authentication_pages/auth_pages/auth_page/auth_page.dart';
import '../blocs/bloc_icon_color/bloc_index.dart';
import '../blocs/bloc_icon_color/bloc_index_event.dart';
import '../compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../compilation_pages/compilation_page/compilation_page.dart';
import '../main_page.dart';
import 'burger_button.dart';

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
                    MainPage.globalKey.currentState!
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
                    User? _user = FirebaseAuth.instance.currentUser;
                    if (_user != null) {
                      MainPage.globalKey.currentState!
                          .pushReplacementNamed(ProfilePage.routName);
                      Scaffold.of(context).openEndDrawer();
                      context.read<BlocIndex>().add(
                        ColorProfile(),
                      );
                    } else {
                      MyApp.firstKey.currentState!
                          .pushReplacementNamed(AuthPage.routName);
                    }
                  },
                ),
                BurgerButton(
                  icon: AppIcons.category,
                  title: 'Подборки',
                  onTap: () {
                    MainPage.globalKey.currentState!
                        .pushReplacementNamed(CompilationPage.routName);
                    Scaffold.of(context).openEndDrawer();
                    context.read<BlocIndex>().add(
                          ColorCategory(),
                        );
                    context.read<CompilationBloc>().add(
                      ToInitialCompilation(),
                    );
                  },
                ),
                BurgerButton(
                  icon: AppIcons.paper,
                  title: 'Все аудиофайлы',
                  onTap: () {
                    MainPage.globalKey.currentState!
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
                    MainPage.globalKey.currentState!
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
                    MainPage.globalKey.currentState!
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
                MainPage.globalKey.currentState!
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
