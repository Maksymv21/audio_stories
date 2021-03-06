import 'package:flutter/material.dart';

import '../pages/compilation_pages/compilation_create_page/compilation_search_page.dart';
import '../pages/compilation_pages/compilation_create_page/create_compilation_page.dart';
import '../pages/compilation_pages/compilation_current_page/compilation_current_page.dart';
import '../pages/compilation_pages/compilation_page/compilation_page.dart';
import '../pages/compilation_pages/pick_few_compilation_page/pick_few_compilation_page.dart';
import '../pages/profile_pages/edit_profile_page.dart';
import '../pages/profile_pages/profile_page.dart';
import '../pages/sounds_contain_pages/audio_page/audio_page.dart';
import '../pages/sounds_contain_pages/home_page/home_page.dart';
import '../pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page.dart';
import '../pages/sounds_contain_pages/search_pages/search_page.dart';
import '../pages/uncategorized_pages/play_page/play_page.dart';
import '../pages/uncategorized_pages/record_page/record_page.dart';
import '../pages/uncategorized_pages/subscription_pages/subscription_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;
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
        final CurrentCompilationPageArguments args =
            arguments as CurrentCompilationPageArguments;
        page = CurrentCompilationPage(
          title: args.title,
          url: args.url,
          text: args.text,
          listId: args.listId,
          date: args.date,
          id: args.id,
        );
        break;
      case CreateCompilationPage.routName:
        page = const CreateCompilationPage();
        break;
      case CompilationSearchPage.routName:
        page = const CompilationSearchPage();
        break;
      case PickFewCompilationPage.routName:
        final PickFewCompilationPageArguments args =
            arguments as PickFewCompilationPageArguments;
        page = PickFewCompilationPage(
          title: args.title,
          url: args.url,
          sounds: args.sounds,
          date: args.date,
          id: args.id,
          text: args.text,
        );
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
        final PlayPageArguments args = arguments as PlayPageArguments;
        page = PlayPage(
          title: args.title,
          id: args.id,
          page: args.page,
          url: args.url,
        );
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
