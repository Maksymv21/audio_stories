import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../blocs/bloc_icon_color/bloc_index.dart';
import '../../../blocs/bloc_icon_color/bloc_index_event.dart';
import '../../../pages/auth_pages/auth_page.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_bloc.dart';
import '../../pages/compilation_pages/compilation_page/compilation_bloc/compilation_event.dart';
import '../../pages/compilation_pages/compilation_page/compilation_page.dart';
import '../../pages/profile_pages/profile_page.dart';
import '../../pages/sounds_contain_pages/audio_page/audio_page.dart';
import '../../pages/sounds_contain_pages/home_page/home_page.dart';
import '../../pages/uncategorized_pages/record_page/record_page.dart';
import '../buttons/foot_button.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({
    Key? key,
  }) : super(key: key);

  void _toPage(
    BuildContext context,
    String route,
    IndexEvent event,
  ) {
    MainPage.globalKey.currentState!.pushReplacementNamed(
      route,
    );
    context.read<BlocIndex>().add(
          event,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: BlocBuilder<BlocIndex, int>(
        builder: (context, index) => Stack(
          children: [
            index == 2
                ? Align(
                    alignment: const AlignmentDirectional(
                      -0.035,
                      -3.5,
                    ),
                    child: Container(
                      width: 4.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: const Color(0x0ff1b488).withOpacity(1.0),
                      ),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FootButton(
                  icon: AppIcons.home,
                  title: 'Главная',
                  color: index == 0 ? AppColor.active : AppColor.disActive,
                  onPressed: () {
                    if (index != 0) {
                      _toPage(
                        context,
                        HomePage.routName,
                        ColorHome(),
                      );
                    }
                  },
                ),
                FootButton(
                  icon: AppIcons.category,
                  title: 'Подборки',
                  color: index == 1 ? AppColor.active : AppColor.disActive,
                  onPressed: () {
                    if (index != 1) {
                      _toPage(
                        context,
                        CompilationPage.routName,
                        ColorCategory(),
                      );
                      context.read<CompilationBloc>().add(
                            ToInitialCompilation(),
                          );
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (index != 2) {
                      _toPage(
                        context,
                        RecordPage.routName,
                        ColorRecord(),
                      );
                    }
                  },
                  child: index == 2 || index == 6
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                            top: 7.0,
                            right: 4.0,
                            bottom: 20.0,
                          ),
                          child: Container(
                            width: 45.0,
                            height: 57.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: const Color(0x0ff1b488).withOpacity(1.0),
                            ),
                          ),
                        )
                      : Container(
                          width: 53.0,
                          height: 57.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                AppIcons.record,
                              ),
                            ),
                          ),
                        ),
                ),
                FootButton(
                  icon: AppIcons.paper,
                  title: 'Ауидозаписи',
                  color: index == 3 ? AppColor.active : AppColor.disActive,
                  onPressed: () {
                    if (index != 3) {
                      _toPage(
                        context,
                        AudioPage.routName,
                        ColorAudio(),
                      );
                    }
                  },
                ),
                FootButton(
                  icon: AppIcons.profile,
                  title: 'Профиль',
                  color: index == 4 ? AppColor.active : AppColor.disActive,
                  onPressed: () {
                    if (index != 4) {
                      User? _user = FirebaseAuth.instance.currentUser;
                      if (_user != null) {
                        _toPage(
                          context,
                          ProfilePage.routName,
                          ColorProfile(),
                        );
                      } else {
                        MyApp.firstKey.currentState!
                            .pushReplacementNamed(AuthPage.routName);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
