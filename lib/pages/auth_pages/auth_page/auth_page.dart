import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth_event.dart';
import 'package:audio_stories/pages/auth_pages/auth_bloc/bloc_auth_state.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/auth_pages/registration_page/registration_page.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:audio_stories/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  static const routName = '/auth';

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();

  AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (previous, current) {
        if (current is PhoneAuthCodeSuccess) {
          User? _user = FirebaseAuth.instance.currentUser;
          LocalDB.phoneNumber = _user?.phoneNumber;
          LocalDB.refactorNumber();
          Utils.firstKey.currentState!.pushReplacementNamed(
            MainPage.routName,
          );
        }
        if (current is PhoneAuthNumberFailure) {
          _showSnackBar(
            context: context,
            text: 'Введен недопустимый номер.'
                '\nПроверьте номер и повторите попытку.',
          );
        }
        if (current is PhoneAuthCodeFailure) {
          _showSnackBar(
            context: context,
            text: 'Неверный код или истекло время ожидания.'
                '\nПовторите попытку еще раз.',
          );
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial ||
            state is PhoneAuthNumberFailure ||
            state is PhoneAuthCodeFailure ||
            state is PhoneAuthCodeSuccess) {
          return _registrationNumberPage(context);
        } else if (state is PhoneAuthNumberSuccess) {
          return _registrationSmsPage(context, state.verificationId);
        } else if (state is PhoneAuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _registrationNumberPage(context) {
    _phoneNumberController.text = '+380';
    return RegistrationPage(
      text: 'Введи номер телефона',
      controller: _phoneNumberController,
      height: 15,
      onPressed: () {
        _verifyPhoneNumber(context);
      },
      widget: TextButton(
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () {
          Utils.firstKey.currentState!.pushNamedAndRemoveUntil(
            MainPage.routName,
            (Route<dynamic> route) => false,
          );
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
    );
  }

  Widget _registrationSmsPage(context, verificationId) {
    return RegistrationPage(
      text: 'Введи код из смс, чтобы мы'
          '\nтебя запомнили',
      controller: _codeNumberController,
      height: 15,
      widget: const SizedBox(
        height: 30.0,
      ),
      onPressed: () {
        _verifySMS(
          context,
          verificationId,
        );
        _codeNumberController.text = '';
      },
    );
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    context.read<PhoneAuthBloc>().add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _verifyPhoneNumber(BuildContext context) {
    context
        .read<PhoneAuthBloc>()
        .add(PhoneAuthNumberVerified(phoneNumber: _phoneNumberController.text));
  }

  void _showSnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class IsChange {
  IsChange._();

  static bool isChange = false;
}
