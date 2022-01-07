import 'package:audio_stories/pages/category_page.dart';
import 'package:audio_stories/pages/home_page.dart';
import 'package:audio_stories/pages/audio_page.dart';
import 'package:audio_stories/pages/profile_page.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/widgets/drawer.dart';
import 'package:audio_stories/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Utils.globalKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          Widget page;

          switch (settings.name) {
            case '/':
              page = const HomePage();
              break;
            case '/paper':
              page = const AudioPage();
              break;
            case '/category':
            page = const CategoryPage();
            break;
            case '/profile':
              page = const ProfilePage();
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
    );
  }
}
