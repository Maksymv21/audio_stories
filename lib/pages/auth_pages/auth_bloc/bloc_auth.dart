import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../auth_model/auth_model.dart';
import '../auth_page/auth_page.dart';
import '../auth_repository/auth_repository.dart';
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
        onVerificationCompleted:
            IsChange.isChange ? _onChangeCompleted : _onVerificationCompleted,
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
        PhoneAuthNumberSuccess(verificationId: event.verificationId),
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
      if (IsChange.isChange) {
        PhoneAuthModel phoneAuthModel =
            await _phoneAuthRepository.verifyChangeSMSCode(
          smsCode: event.smsCode,
          verificationId: event.verificationId,
        );
        emit(
          PhoneAuthCodeSuccess(uid: phoneAuthModel.uid),
        );
      } else {
        PhoneAuthModel phoneAuthModel =
            await _phoneAuthRepository.verifySMSCode(
          smsCode: event.smsCode,
          verificationId: event.verificationId,
        );
        emit(
          PhoneAuthCodeSuccess(uid: phoneAuthModel.uid),
        );
      }
    });
    on<ChangeAuthCodeVerified>((event, emit) async {
      emit(PhoneAuthLoading());
      if (IsChange.isChange) {
        PhoneAuthModel phoneAuthModel =
            await _phoneAuthRepository.verifyChangeSMSCode(
          smsCode: event.smsCode,
          verificationId: event.verificationId,
        );
        emit(
          PhoneAuthCodeSuccess(uid: phoneAuthModel.uid),
        );
      } else {
        PhoneAuthModel phoneAuthModel =
            await _phoneAuthRepository.verifySMSCode(
          smsCode: event.smsCode,
          verificationId: event.verificationId,
        );
        emit(
          PhoneAuthCodeSuccess(uid: phoneAuthModel.uid),
        );
      }
    });
  }

  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    final PhoneAuthModel phoneAuthModel =
        await _phoneAuthRepository.verifyWithCredential(credential: credential);
    if (phoneAuthModel.phoneAuthModelState == PhoneAuthModelState.verified) {
      add(PhoneAuthVerificationCompleted(phoneAuthModel.uid));
    }
  }

  void _onChangeCompleted(PhoneAuthCredential credential) async {
    final PhoneAuthModel phoneAuthModel = await _phoneAuthRepository
        .updateNumberWithCredential(credential: credential);
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
