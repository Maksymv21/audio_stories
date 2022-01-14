import 'package:audio_stories/model/auth_model.dart';
import 'package:audio_stories/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthRepository {
  final PhoneAuthFirebaseProvider _phoneAuthFirebaseProvider;
  PhoneAuthRepository({
    required PhoneAuthFirebaseProvider phoneAuthFirebaseProvider,
  }) : _phoneAuthFirebaseProvider = phoneAuthFirebaseProvider;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required onVerificationCompleted,
    required onVerificationFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
  }) async {
    await _phoneAuthFirebaseProvider.verifyPhoneNumber(
        onCodeAutoRetrievalTimeOut: onCodeAutoRetrievalTimeOut,
        onCodeSent: onCodeSent,
        onVerificationFailed: onVerificationFailed,
        onVerificationCompleted: onVerificationCompleted,
        mobileNumber: phoneNumber);
  }

  Future<PhoneAuthModel> verifySMSCode({
    required String smsCode,
    required String verificationId,
  }) async {
    final User? user =
    await _phoneAuthFirebaseProvider.loginWithSMSVerificationCode(
        verificationId: verificationId, smsVerificationCode: smsCode);
    if (user != null) {
      return PhoneAuthModel(
        phoneAuthModelState: PhoneAuthModelState.verified,
        uid: user.uid,
      );
    } else {
      return PhoneAuthModel(phoneAuthModelState: PhoneAuthModelState.error);
    }
  }

  Future<PhoneAuthModel> verifyWithCredential({
    required AuthCredential credential,
  }) async {
    User? user = await _phoneAuthFirebaseProvider.authenticationWithCredential(
      credential: credential,
    );
    if (user != null) {
      return PhoneAuthModel(
        phoneAuthModelState: PhoneAuthModelState.verified,
        uid: user.uid,
      );
    } else {
      return PhoneAuthModel(phoneAuthModelState: PhoneAuthModelState.error);
    }
  }
}