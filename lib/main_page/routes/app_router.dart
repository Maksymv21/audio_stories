import 'package:flutter/material.dart';

import '../pages/compilation_pages/compilation_create_page/compilation_search_page.dart';
import '../pages/compilation_pages/compilation_create_page/create_compilation_page.dart';
import '../pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../pages/compilation_pages/compilation_page/compilation_page.dart';
import '../pages/compilation_pages/pick_few_compilation_page/pick_few_compilation_page.dart';
import '../pages/profile_pages/profile_page/edit_profile_page.dart';
import '../pages/profile_pages/profile_page/profile_page.dart';
import '../pages/sounds_contain_pages/audio_page/audio_page/audio_page.dart';
import '../pages/sounds_contain_pages/audio_page/audio_page/test_page.dart';
import '../pages/sounds_contain_pages/home_pages/home_page/home_page.dart';
import '../pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import '../pages/sounds_contain_pages/search_pages/search_page/search_page.dart';
import '../pages/uncategorized_pages/play_page/play_page.dart';
import '../pages/uncategorized_pages/record_page/record_page.dart';
import '../pages/uncategorized_pages/subscription_pages/subscription_page/subscription_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
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
      case CurrentCompilationPage.routName:
        page = const CurrentCompilationPage();
        break;
      case CreateCompilationPage.routName:
        page = const CreateCompilationPage();
        break;
      case CompilationSearchPage.routName:
        page = const CompilationSearchPage();
        break;
      case PickFewCompilationPage.routName:
        page = PickFewCompilationPage();
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
  }
}
