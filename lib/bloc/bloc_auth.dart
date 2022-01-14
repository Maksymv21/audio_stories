import 'dart:async';

import 'package:audio_stories/bloc/bloc_auth_event.dart';
import 'package:audio_stories/bloc/bloc_auth_state.dart';
import 'package:audio_stories/model/auth_model.dart';
import 'package:audio_stories/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository _phoneAuthRepository;

  PhoneAuthBloc({required PhoneAuthRepository phoneAuthRepository})
      : _phoneAuthRepository = phoneAuthRepository,
        super(PhoneAuthInitial()) {
    on<PhoneAuthNumberVerified>(
      _phoneAuthNumberVerifiedToState,
    );
    on<PhoneAuthCodeAutoReturnTimeout>(
      _phoneAuthCodeAutoReturnTimeoutComplete,
    );
    on<PhoneAuthCodeSent>(
      _phoneAuthNumberVerificationSuccess,
    );
    on<PhoneAuthVerificationFailed>(
      _phoneAuthNumberVerificationFailure,
    );
    on<PhoneAuthVerificationCompleted>(
      _phoneAuthCodeVerificationSuccess,
    );
    on<PhoneAuthCodeVerified>(
      _phoneAuthCodeVerifiedToState,
    );
    on<DeletedAccount>(
      _repeatPhoneAuth,
    );
  }

  Future<void> _phoneAuthNumberVerifiedToState(
    PhoneAuthNumberVerified event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('1');
    emit(PhoneAuthLoading());
    await _phoneAuthRepository.verifyPhoneNumber(
      phoneNumber: event.phoneNumber,
      onCodeAutoRetrievalTimeOut: _onCodeAutoRetrievalTimeout,
      onCodeSent: _onCodeSent,
      onVerificationCompleted: _onVerificationCompleted,
      onVerificationFailed: _onVerificationFailed,
    );
  }

  Future<void> _phoneAuthCodeVerifiedToState(
    PhoneAuthCodeVerified event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('2');
    emit(PhoneAuthLoading());
    PhoneAuthModel phoneAuthModel = await _phoneAuthRepository.verifySMSCode(
      smsCode: event.smsCode,
      verificationId: event.verificationId,
    );
    emit(
      PhoneAuthCodeVerificationSuccess(uid: phoneAuthModel.uid),
    );
  }

  _phoneAuthCodeAutoReturnTimeoutComplete(
    PhoneAuthCodeAutoReturnTimeout event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('3');
    emit(
      PhoneAuthCodeAutoReturnTimeoutComplete(event.verificationId),
    );
  }

  _phoneAuthNumberVerificationSuccess(
    PhoneAuthCodeSent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('4');
    emit(
      PhoneAuthNumberVerificationSuccess(verificationId: event.verificationId),
    );
  }

  _phoneAuthNumberVerificationFailure(
    PhoneAuthVerificationFailed event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('5');
    emit(
      PhoneAuthNumberVerificationFailure(event.message),
    );
  }

  _phoneAuthCodeVerificationSuccess(
    PhoneAuthVerificationCompleted event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('6');
    emit(
      PhoneAuthCodeVerificationSuccess(uid: event.uid),
    );
  }

  _repeatPhoneAuth(
    DeletedAccount event,
    Emitter<PhoneAuthState> emit,
  ) async {
    print('7');
    emit(
      RepeatPhoneAuth(),
    );
  }

  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    final PhoneAuthModel phoneAuthModel =
        await _phoneAuthRepository.verifyWithCredential(credential: credential);
    if (phoneAuthModel.phoneAuthModelState == PhoneAuthModelState.verified) {
      add(PhoneAuthVerificationCompleted(phoneAuthModel.uid));
    }
  }

  void _onVerificationFailed(FirebaseException exception) {
    add(PhoneAuthVerificationFailed(exception.toString()));
  }

  void _onCodeSent(String verificationId, int? token) {
    add(PhoneAuthCodeSent(
      token: token,
      verificationId: verificationId,
    ));
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    add(PhoneAuthCodeAutoReturnTimeout(verificationId));
  }
}
