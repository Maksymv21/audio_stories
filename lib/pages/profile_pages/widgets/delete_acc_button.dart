import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/auth_pages/registration_page/registration_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          print(user);
          await user?.delete();
          Utils.firstKey.currentState!
              .pushReplacementNamed(WelcomePage.routName);
          RegistrationOrAuthText.text = 'Регистрация';
        } catch (e) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  shape: ShapeBorder.lerp(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      const CircleBorder(),
                      0.3),
                  title: const Text(
                    'Для данного действия нужно авторизоваться',
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    'Желаете продолжить?',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(
                              context, 'Cancel'),
                          child: const Text(
                            'Нет',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Utils.firstKey.currentState!
                                .pushReplacementNamed(
                                AuthPage.routName);
                            RegistrationOrAuthText.text =
                            'Авторизация';
                          },
                          child: const Text(
                            'Да',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                    ),
                  ],
                ),
          );
        }
      },
      child: const Text(
        'Удалить аккаунт',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
