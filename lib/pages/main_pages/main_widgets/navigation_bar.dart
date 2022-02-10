import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/audio_pages/audio_page/audio_page.dart';
import 'package:audio_stories/pages/category_pages/category_page/category_page.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index.dart';
import 'package:audio_stories/pages/main_pages/main_blocs/bloc_icon_color/bloc_index_event.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/profile_page.dart';
import 'package:audio_stories/pages/profile_pages/profile_page/test_rieastore_page.dart';
import 'package:audio_stories/pages/record_page/record_page.dart';
import 'package:audio_stories/resources/app_color.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/pages/main_pages/main_widgets/foot_button.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
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
                    alignment: const AlignmentDirectional(-0.035, -3.5),
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
                      Utils.globalKey.currentState!
                          .pushReplacementNamed(MainPage.routName);
                      context.read<BlocIndex>().add(
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
                    // if index != 1
                    if (index != 1) {
                      Utils.globalKey.currentState!
                          .pushReplacementNamed(CategoryPage.routName);
                      context.read<BlocIndex>().add(
                            ColorCategory(),
                          );
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (index != 2) {
                      Utils.globalKey.currentState!
                          .pushReplacementNamed(RecordPage.routName);
                      context.read<BlocIndex>().add(
                            ColorRecord(),
                          );
                    }
                  },
                  child: index == 2
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, top: 7.0, right: 4.0, bottom: 20.0),
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
                      Utils.globalKey.currentState!
                          .pushReplacementNamed(TestPage.routName);
                      context.read<BlocIndex>().add(
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
                        Utils.globalKey.currentState!
                            .pushReplacementNamed(ProfilePage.routName);
                        context.read<BlocIndex>().add(
                              ColorProfile(),
                            );
                      } else {
                        Utils.firstKey.currentState!
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
