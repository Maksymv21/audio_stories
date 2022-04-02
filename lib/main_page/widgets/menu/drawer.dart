import 'package:audio_stories/main_page/pages/sounds_contain_pages/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../../main.dart';
import '../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../pages/auth_pages/auth_page/auth_page.dart';
import '../../../resources/app_icons.dart';
import '../../main_page.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../pages/compilation_pages/compilation_page/compilation_page.dart';
import '../../pages/profile_pages/profile_page/profile_page.dart';
import '../../pages/sounds_contain_pages/audio_page/audio_page/audio_page.dart';
import '../../pages/sounds_contain_pages/recently_deleted_pages/recently_deleted_page/recently_deleted_page.dart';
import '../../pages/sounds_contain_pages/search_pages/search_page/search_page.dart';
import '../../pages/uncategorized_pages/subscription_pages/subscription_page/subscription_page.dart';
import '../buttons/burger_button.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  void _toPage(
    BuildContext context,
    String page,
    IndexEvent event,
  ) {
    MainPage.globalKey.currentState!.pushReplacementNamed(page);
    Scaffold.of(context).openEndDrawer();
    context.read<BlocIndex>().add(
          event,
        );
  }

  void _toHome(BuildContext context) {
    _toPage(
      context,
      HomePage.routName,
      ColorHome(),
    );
  }

  void _toProfile(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _toPage(
        context,
        ProfilePage.routName,
        ColorProfile(),
      );
    } else {
      MyApp.firstKey.currentState!.pushReplacementNamed(
        AuthPage.routName,
      );
    }
  }

  void _toCompilation(BuildContext context) {
    _toPage(
      context,
      CompilationPage.routName,
      ColorCategory(),
    );
    context.read<CompilationBloc>().add(
          ToInitialCompilation(),
        );
  }

  void _toAudios(BuildContext context) {
    _toPage(
      context,
      AudioPage.routName,
      ColorAudio(),
    );
  }

  void _toSearch(BuildContext context) {
    _toPage(
      context,
      SearchPage.routName,
      NoColor(),
    );
  }

  void _toDeleted(BuildContext context) {
    _toPage(
      context,
      RecentlyDeletedPage.routName,
      NoColor(),
    );
  }

  void _toSubscription(BuildContext context) {
    _toPage(
      context,
      SubscriptionPage.routName,
      NoColor(),
    );
  }

  Future<void> _sendEmail() async {
    final Email email = Email(
      subject: 'Support',
      recipients: ['maksymv21@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

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
                  onTap: () => _toHome(context),
                ),
                BurgerButton(
                  icon: AppIcons.profile,
                  title: 'Профиль',
                  onTap: () => _toProfile(context),
                ),
                BurgerButton(
                  icon: AppIcons.category,
                  title: 'Подборки',
                  onTap: () => _toCompilation(context),
                ),
                BurgerButton(
                  icon: AppIcons.paper,
                  title: 'Все аудиофайлы',
                  onTap: () => _toAudios(context),
                ),
                BurgerButton(
                  icon: AppIcons.search,
                  title: 'Поиск',
                  onTap: () => _toSearch(context),
                ),
                BurgerButton(
                  icon: AppIcons.delete,
                  title: 'Недавно удаленные',
                  onTap: () => _toDeleted(context),
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
              onTap: () => _toSubscription(context),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: BurgerButton(
              icon: AppIcons.edit,
              title: 'Написать в '
                  '\nподдержку',
              onTap: () => _sendEmail(),
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
