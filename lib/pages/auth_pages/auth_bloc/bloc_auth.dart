import 'package:audio_stories/pages/auth_pages/auth_model/auth_model.dart';
import 'package:audio_stories/pages/auth_pages/auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_auth_event.dart';
import 'bloc_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository _phoneAuthRepository;

  PhoneAuthBloc({required PhoneAuthRepository phoneAuthRepository})
      : _phoneAuthRepository = phoneAuthRepository,
        super(PhoneAuthInitial()) {
    on<PhoneAuthNumberVerified>((event, emit) async {
      emit(PhoneAuthLoading());
      await _phoneAuthRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeSent: _onCodeSent,
        onVerificationFailed: _onVerificationFailed,
        onVerificationCompleted: _onVerificationCompleted,
        onCodeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
      );
    });
    on<PhoneAuthCodeAutoReturnTimeout>((event, emit) async {
      emit(
        PhoneAuthCodeFailure(),
      );
    });
    on<PhoneAuthCodeSent>((event, emit) async {
      emit(
        PhoneAuthNumberSuccess(
            verificationId: event.verificationId),
      );
    });
    on<PhoneAuthVerificationFailed>((event, emit) async {
      emit(
        PhoneAuthNumberFailure(),
      );
    });
    on<PhoneAuthVerificationCompleted>((event, emit) async {
      emit(
        PhoneAuthCodeSuccess(uid: event.uid),
      );
    });
    on<PhoneAuthCodeVerified>((event, emit) async {
      emit(PhoneAuthLoading());
      PhoneAuthModel phoneAuthModel = await _phoneAuthRepository.verifySMSCode(
        smsCode: event.smsCode,
        verificationId: event.verificationId,
      );
      emit(
        PhoneAuthCodeSuccess(uid: phoneAuthModel.uid),
      );
    });
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
