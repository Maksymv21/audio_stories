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
        onCodeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        onCodeSent: _onCodeSent,
        onVerificationCompleted: _onVerificationCompleted,
        onVerificationFailed: _onVerificationFailed,
      );
    });
    on<PhoneAuthCodeAutoReturnTimeout>((event, emit) async {
      emit(
        PhoneAuthCodeAutoReturnTimeoutComplete(event.verificationId),
      );
    });
    on<PhoneAuthCodeSent>((event, emit) async {
      emit(
        PhoneAuthNumberVerificationSuccess(
            verificationId: event.verificationId),
      );
    });
    on<PhoneAuthVerificationFailed>((event, emit) async {
      emit(
        PhoneAuthNumberVerificationFailure(event.message),
      );
    });
    on<PhoneAuthVerificationCompleted>((event, emit) async {
      emit(
        PhoneAuthCodeVerificationSuccess(uid: event.uid),
      );
    });
    on<PhoneAuthCodeVerified>((event, emit) async {
      emit(PhoneAuthLoading());
      PhoneAuthModel phoneAuthModel = await _phoneAuthRepository.verifySMSCode(
        smsCode: event.smsCode,
        verificationId: event.verificationId,
      );
      emit(
        PhoneAuthCodeVerificationSuccess(uid: phoneAuthModel.uid),
      );
    });
    on<DeletedAccount>((event, emit) async {
      emit(
        RepeatPhoneAuth(),
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
