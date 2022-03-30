import 'package:audio_stories/main_page/pages/compilation_pages/compilation_create_page/compilation_create_bloc/add_in_compilation_bloc.dart';
import 'package:audio_stories/main_page/pages/compilation_pages/compilation_current_page/compilation_current_bloc/compilation_current_bloc.dart';
import 'package:audio_stories/main_page/pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import 'package:audio_stories/main_page/routes/app_router.dart';
import 'package:audio_stories/main_page/widgets/drawer.dart';
import 'package:audio_stories/main_page/widgets/navigation_bar.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/custom_will_pop_scope.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc_icon_color/bloc_index.dart';
import '../pages/auth_pages/auth_repository/auth_repository.dart';

class MainPage extends StatefulWidget {
  static GlobalKey<NavigatorState> globalKey = GlobalKey();
  static const routName = '/main';

  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? _user = firebaseAuth.currentUser;
    if (_user != null) {
      LocalDB.uid = _user.uid;

      PhoneAuthRepository(firebaseAuth: firebaseAuth).createUser();
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocIndex(0),
        ),
        BlocProvider(
          create: (context) => AddInCompilationBloc(),
        ),
        BlocProvider(
          create: (context) => CompilationCurrentBloc(),
        ),
        BlocProvider(
          create: (context) => CompilationBloc(),
        ),
      ],
      child: CustomWillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Navigator(
            key: MainPage.globalKey,
            initialRoute: MainPage.routName,
            onGenerateRoute: AppRouter.generateRoute,
          ),
          bottomNavigationBar: const MyNavigationBar(),
          drawer: const BurgerMenu(),
        ),
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
