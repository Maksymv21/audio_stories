import 'package:audio_stories/pages/audio_pages/audio_page/test_page.dart';
import 'package:audio_stories/pages/auth_pages/auth_repository/auth_repository.dart';
import 'package:audio_stories/pages/home_pages/home_page/home_page.dart';
import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/widgets/drawer.dart';
import 'package:audio_stories/pages/main_pages/widgets/navigation_bar.dart';
import 'package:audio_stories/pages/play_page/play_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/edit_profile_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import 'package:audio_stories/pages/record_page/record_page.dart';
import 'package:audio_stories/pages/search_pages/search_page/search_page.dart';
import 'package:audio_stories/pages/subscription_pages/subscription_page/subscription_page.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../compilation_pages/compilation_page/create_compilation_page.dart';
import '../../compilation_pages/compilation_page/compilation_page.dart';
import '../../compilation_pages/compilation_page/compilation_search_page.dart';


class MainPage extends StatelessWidget {
  static GlobalKey<NavigatorState> globalKey = GlobalKey();
  static const routName = '/main';

  const MainPage({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? _user = firebaseAuth.currentUser;
    if (_user != null) {
      LocalDB.uid = _user.uid;

      PhoneAuthRepository(firebaseAuth: firebaseAuth).createUser();
    }
    return BlocProvider(
      create: (context) => BlocIndex(0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Navigator(
          key: globalKey,
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
              case CompilationPage.routName:
                page = const CompilationPage();
                break;
              case CreateCompilationPage.routName:
                page = const CreateCompilationPage();
                break;
              case CompilationSearchPage.routName:
                page = const CompilationSearchPage();
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
              case RecordPage.routName:
                page = const RecordPage();
                break;
              case PlayPage.routName:
                page = PlayPage();
                break;
              case TestPage.routName:
                page = const TestPage();
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

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}

