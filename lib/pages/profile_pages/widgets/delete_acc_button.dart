import 'package:audio_stories/pages/auth_pages/auth_page/auth_page.dart';
import 'package:audio_stories/pages/auth_pages/registration_page/registration_page.dart';
import 'package:audio_stories/pages/welcome_pages/welcome_page/welcome_page.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/widgets/dialog_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => DialogProfile(
              title: 'После удаления аккаунта все данные будут утеряны',
              onPressedNo: () => Navigator.pop(context, 'Cancel'),
              onPressedYes: () async {
                FirebaseStorage _storage = FirebaseStorage.instance;
                try {
                  await _storage
                      .ref()
                      .child('Images')
                      .child(
                        LocalDB.uid.toString(),
                      )
                      .delete();
                  await _storage
                      .ref()
                      .child('Sounds')
                      .child(LocalDB.uid.toString())
                      .delete();
                } catch (e) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => DialogProfile(
                      title: 'Для данного действия нужно авторизоваться',
                      onPressedNo: () => Navigator.pop(context, 'Cancel'),
                      onPressedYes: () {
                        MyApp.firstKey.currentState!.pushNamedAndRemoveUntil(
                          AuthPage.routName,
                          (Route<dynamic> route) => false,
                        );
                        RegistrationPageText.header = 'Авторизация';
                        IsChange.isChange = false;
                      },
                    ),
                  );
                }
                User? user = FirebaseAuth.instance.currentUser;
                await user?.delete();
                await Database.delete(user!.uid);
                MyApp.firstKey.currentState!.pushNamedAndRemoveUntil(
                  WelcomePage.routName,
                  (Route<dynamic> route) => false,
                );
                RegistrationPageText.header = 'Регистрация';
                IsChange.isChange = false;
              },
            ),
          );
        } catch (e) {
          debugPrint(e.toString());
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
