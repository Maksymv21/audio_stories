import 'package:audio_stories/bloc/bloc_icon_color.dart';
import 'package:audio_stories/pages/category_page.dart';
import 'package:audio_stories/pages/home_page.dart';
import 'package:audio_stories/pages/audio_page.dart';
import 'package:audio_stories/pages/profile_page.dart';
import 'package:audio_stories/pages/recently_deleted_page.dart';
import 'package:audio_stories/pages/search_page.dart';
import 'package:audio_stories/pages/subscription_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/drawer.dart';
import 'package:audio_stories/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
      child: Scaffold(
        body: Navigator(
          key: Utils.globalKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            Widget page;

            switch (settings.name) {
              case '/':
                page = const HomePage();
                break;
              case '/audio':
                page = const AudioPage();
                break;
              case '/category':
                page = const CategoryPage();
                break;
              case '/profile':
                page = const ProfilePage();
                break;
              case '/search':
                page = const SearchPage();
                break;
              case '/deleted':
                page = const RecentlyDeletedPage();
                break;
              case '/subscription':
                page = const SubscriptionPage();
                break;
              default:
                page = const HomePage();
                break;
            }

            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => page,
              transitionDuration: const Duration(
                seconds: 0,
              ),
            );
          },
        ),
        bottomNavigationBar: const MyNavigationBar(),
        drawer: const BurgerMenu(),
      ),
    );
  }
}
