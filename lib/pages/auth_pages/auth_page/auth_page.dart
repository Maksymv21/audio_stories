import 'package:audio_stories/pages/auth_bloc/bloc_auth.dart';
import 'package:audio_stories/pages/auth_bloc/bloc_auth_event.dart';
import 'package:audio_stories/pages/auth_bloc/bloc_auth_state.dart';
import 'package:audio_stories/pages/main_pages/main_page/main_page.dart';
import 'package:audio_stories/pages/auth_pages/registration_page/registration_page.dart';
import 'package:audio_stories/resources/utils.dart';
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
        if (current is PhoneAuthCodeVerificationSuccess) {
          Utils.firstKey.currentState!.pushReplacementNamed(
            MainPage.routName,
          );
        } else if (current is PhoneAuthCodeVerificationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthError) {
          _showSnackBarWithText(
              context: context, textValue: 'Expected error occurred.');
        } else if (current is PhoneAuthNumberVerificationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthNumberVerificationSuccess) {
          _showSnackBarWithText(
              context: context,
              textValue: 'SMS code is sent to your mobile number.');
        } else if (current is PhoneAuthCodeAutoReturnTimeoutComplete) {
          _showSnackBarWithText(
              context: context, textValue: 'Time out for auto retrieval');
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial) {
          return _registrationNumberPage(context);
        } else if (state is PhoneAuthNumberVerificationSuccess) {
          return _registrationSmsPage(context, state.verificationId);
        } else if (state is PhoneAuthNumberVerificationFailure) {
          return _registrationNumberPage(context);
        } else if (state is PhoneAuthCodeVerificationFailure) {
          return _registrationSmsPage(context, state.verificationId);
        } else if (state is RepeatPhoneAuth) {
          _registrationNumberPage(context);
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
    return RegistrationPage(
      text: 'Введи номер телефона',
      controller: _phoneNumberController,
      height: 15,
      hintText: '380',
      onPressed: () {
        _verifyPhoneNumber(context);
      },
      widget: TextButton(
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
    );
  }

  Widget _registrationSmsPage(context, verificationId) {
    return RegistrationPage(
      text: 'Введи код из смс, чтобы мы'
          '\nтебя запомнили',
      controller: _codeNumberController,
      height: 15,
      hintText: '',
      widget: const SizedBox(
        height: 30.0,
      ),
      onPressed: () {
        _verifySMS(
          context,
          verificationId,
        );
      },
    );
  }

  void _verifyPhoneNumber(BuildContext context) {
    context.read<PhoneAuthBloc>().add(PhoneAuthNumberVerified(
        phoneNumber: '+' + _phoneNumberController.text));
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    context.read<PhoneAuthBloc>().add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _showSnackBarWithText(
      {required BuildContext context, required String textValue}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textValue)));
  }
}
