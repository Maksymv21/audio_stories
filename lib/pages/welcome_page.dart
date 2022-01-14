import 'package:audio_stories/bloc/bloc_auth_event.dart';
import 'package:audio_stories/bloc/bloc_auth_state.dart';
import 'package:audio_stories/pages/auth_page.dart';
import 'package:audio_stories/provider/auth_provider.dart';
import 'package:audio_stories/repository/auth_repository.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/continue_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:audio_stories/bloc/bloc_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  static const routName = '/welcome';

  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthBloc(
        phoneAuthRepository: PhoneAuthRepository(
          phoneAuthFirebaseProvider: PhoneAuthFirebaseProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Background(
              height: 300.0,
              image: AppIcons.up,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(31.0),
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
                Utils.firstKey.currentState!.pushNamedAndRemoveUntil(
                  AuthPage.routName,
                  (Route<dynamic> route) => false,
                );
                context.read<PhoneAuthBloc>().emit(
                      PhoneAuthInitial(),
                    );
                // context.read<PhoneAuthBloc>().add(
                //       DeletedAccount(),
                //     );
              },
            ),
          ],
        ),
      ),
    );
  }
}
