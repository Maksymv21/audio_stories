import 'package:audio_stories/pages/main_pages/main_blocs/color_icon_bloc/color_icon_bloc.dart';
import 'package:audio_stories/pages/category_pages/category_page/category_page.dart';
import 'package:audio_stories/pages/home_pages/home_page/home_page.dart';
import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/edit_profile_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/test_rieastore_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/pages/search_pages/search_page/search_page.dart';
import 'package:audio_stories/pages/subscription_pages/subscription_page/subscription_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/drawer.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  static const routName = '/main';

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
        resizeToAvoidBottomInset: false,
        body: Navigator(
          key: Utils.globalKey,
          initialRoute: MainPage.routName,
          onGenerateRoute: (RouteSettings settings) {
            Widget page;

            switch (settings.name) {
              case HomePage.routName:
                page = const HomePage();
                break;
              case AudioPage.routName:
                page = const AudioPage();
                break;
              case CategoryPage.routName:
                page = const CategoryPage();
                break;
              case ProfilePage.routName:
                page = const ProfilePage();
                break;
              case SearchPage.routName:
                page = const SearchPage();
                break;
              case RecentlyDeletedPage.routName:
                page = const RecentlyDeletedPage();
                break;
              case SubscriptionPage.routName:
                page = const SubscriptionPage();
                break;
              case EditProfilePage.routName:
                page = EditProfilePage();
                break;
              case TestPage.routName:
                page = TestPage();
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
