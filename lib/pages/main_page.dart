import 'package:audio_stories/routes/app_router.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/menu/drawer.dart';
import 'package:audio_stories/widgets/menu/navigation_bar.dart';
import 'package:audio_stories/widgets/uncategorized/custom_will_pop_scope.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc_icon_color/bloc_index.dart';
import '../pages/auth_pages/auth_repository/auth_repository.dart';
import 'compilation_pages/compilation_create_page/compilation_create_bloc/add_in_compilation_bloc.dart';
import 'compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';

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
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final User? _user = _firebaseAuth.currentUser;
    if (_user != null) {
      LocalDB.uid = _user.uid;
      PhoneAuthRepository(firebaseAuth: _firebaseAuth).createUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlocIndex(0),
        ),
        BlocProvider(
          create: (context) => AddInCompilationBloc(),
        ),
        BlocProvider(
          create: (context) => CompilationBloc(),
        ),
      ],
      child: CustomWillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            onPanUpdate: (details) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Navigator(
              key: MainPage.globalKey,
              initialRoute: MainPage.routName,
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
          bottomNavigationBar: const MyNavigationBar(),
          drawer: const BurgerMenu(),
        ),
      ),
    );
  }
}
