import 'package:audio_stories/pages/main_page.dart';
import 'package:audio_stories/widgets/background.dart';
import 'package:audio_stories/widgets/continue_button.dart';
import 'package:audio_stories/resources/app_icons.dart';
import 'package:audio_stories/resources/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  static const routName = '/registration';

  RegistrationPage({Key? key}) : super(key: key);

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIdReceived = '';

  bool otpCodeVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Background(
            height: 300.0,
            image: AppIcons.up,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Регистрация',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 48.0,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            'Введи номер телефона',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'TTNormsL',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          PhysicalModel(
            color: Colors.white,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(45.0),
            child: TextFormField(
              controller: phoneController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                letterSpacing: 1.0,
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                constraints: BoxConstraints(
                  maxWidth: 309.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(45.0),
                  ),
                ),
              ),
            ),
          ),
          // TextFormField(
          //   controller: otpController,
          // ),
          const SizedBox(
            height: 80.0,
          ),
          ContinueButton(
            onPressed: () async{
              if (otpCodeVisible) {
                verifyOtp();
              } else {
                verifyNumber();
              }
              // Utils.firstKey.currentState!.pushNamed('/sms');
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              Utils.firstKey.currentState!.pushNamed(MainPage.routName);
            },
            child: const Text(
              'Позже',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          PhysicalModel(
            color: Colors.white,
            elevation: 4.0,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              width: 280.0,
              height: 110.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Регистрация привяжет твои сказки'
                  '\nк облаку, после чего они всегда '
                  '\nбудут с тобой',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'TTNormsL',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void verifyNumber() {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException exception) {},
      codeSent: (String verificationId, int? resendToken) {
        verificationIdReceived = verificationId;
        otpCodeVisible = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIdReceived,
      smsCode: otpController.text,
    );
    await auth.signInWithCredential(credential);
  }
}
