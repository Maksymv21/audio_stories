import 'package:audio_stories/main.dart';
import 'package:audio_stories/resources/app_images.dart';
import 'package:audio_stories/widgets/buttons/continue_button.dart';
import 'package:audio_stories/widgets/uncategorized/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_pages/auth_bloc/bloc_auth.dart';
import '../auth_pages/auth_page.dart';
import '../auth_pages/auth_repository/auth_repository.dart';

class WelcomePage extends StatelessWidget {
  static const routName = '/welcome';

  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthBloc(
        phoneAuthRepository: PhoneAuthRepository(
          firebaseAuth: FirebaseAuth.instance,
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Background(
              height: 300.0,
              image: AppImages.up,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'MemoryBox',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 48.0,
                          letterSpacing: 3.5,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Твой голос всегда рядом',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Привет!',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              'Мы рады видеть тебя здесь.'
              '\nЭто приложение поможет записывать '
              '\nсказки и держать их в удобном месте не '
              '\nзаполняя память на телефоне',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'TTNormsL',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 45.0,
            ),
            ContinueButton(
              onPressed: () {
                MyApp.firstKey.currentState!.pushNamedAndRemoveUntil(
                  AuthPage.routName,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
