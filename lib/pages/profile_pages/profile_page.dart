import 'dart:math';

import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:audio_stories/widgets/uncategorized/dialog_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../pages/auth_pages/auth_page.dart';
import '../../../pages/auth_pages/registration_page.dart';
import '../../widgets/buttons/button_menu.dart';
import 'widgets/delete_acc_button.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  static const routName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Background(
                height: 375.0,
                image: AppImages.up,
                child: Align(
                  alignment: AlignmentDirectional(
                    -1.1,
                    -0.95,
                  ),
                  child: ButtonMenu(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(LocalDB.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              String? _url = snapshot.data?.data()?['imageURL'];
              String? _name = snapshot.data?.data()?['name'];
              int? memoryInt = snapshot.data?.data()?['totalMemory'];
              memoryInt ??= 0;
              String? memory = (memoryInt / pow(10, 6)).toStringAsFixed(0);
              if (_name == '') {
                _name = 'Ваше имя';
              }
              return Center(
                child: Column(
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    const Expanded(
                      flex: 6,
                      child: Text(
                        'Профиль',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36.0,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Твоя частичка',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.29,
                      height: MediaQuery.of(context).size.height * 0.29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        image: DecorationImage(
                          image: _url == null
                              ? Image.asset(AppImages.photo).image
                              : Image.network(_url).image,
                          fit: BoxFit.cover,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Text(
                        _name ?? 'Ваше имя',
                        style: const TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 7,
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 6.0,
                        borderRadius: BorderRadius.circular(45.0),
                        child: SizedBox(
                          width: 319.0,
                          height: 62.0,
                          child: Center(
                            child: Text(
                              LocalDB.profileNumber!,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: TextButton(
                        onPressed: () {
                          MainPage.globalKey.currentState!
                              .pushReplacementNamed(EditProfilePage.routName);
                        },
                        child: const Text(
                          'Редактировать',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Подписка',
                          style: TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _CustomProgress(
                        value: memoryInt.toDouble(),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '$memory/500 мб',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              _dialog(context);
                            },
                            child: const Text(
                              'Выйти из приложения',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const DeleteAccButton(),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  Future<String?> _dialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => DialogProfile(
        title: 'Выход из аккаунта. \nЧтобы войти введите '
            'уже существующий номер на странице регестрации',
        onPressedNo: () => Navigator.pop(context, 'Cancel'),
        onPressedYes: () {
          FirebaseAuth.instance.signOut();
          MyApp.firstKey.currentState!.pushNamedAndRemoveUntil(
            AuthPage.routName,
            (Route<dynamic> route) => false,
          );
          RegistrationPageText.header = 'Регистрация';
          IsChange.isChange = false;
        },
      ),
    );
  }
}

class _CustomProgress extends StatelessWidget {
  const _CustomProgress({
    Key? key,
    required this.value,
  }) : super(key: key);
  final double value;

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xffF1B488);
    final double max = (5 * pow(10, 8)).toDouble();
    if (value > max) {
      color = Colors.red;
    }
    double width = MediaQuery.of(context).size.width * 0.78;
    double padding = width * (1.0 - (value > max ? max : value) / max);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        width: width,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(right: padding),
                child: ClipRRect(
                  child: Container(
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
