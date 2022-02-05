import 'package:audio_stories/pages/auth_pages/auth_model/auth_model.dart';
import 'package:audio_stories/utils/database.dart';
import 'package:audio_stories/utils/local_db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthRepository {
  final FirebaseAuth _firebaseAuth;

  PhoneAuthRepository({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required onVerificationCompleted,
    required onVerificationFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      timeout: const Duration(
        seconds: 20,
      ),
    );
  }

  Future<PhoneAuthModel> verifySMSCode({
    required String smsCode,
    required String verificationId,
  }) async {
    final User? user = await loginWithSMSVerificationCode(
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

  Future<PhoneAuthModel> verifyChangeSMSCode({
    required String smsCode,
    required String verificationId,
  }) async {
    final User? user = await changeSMSVerificationCode(
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

  Future<User?> loginWithSMSVerificationCode(
      {required String verificationId,
      required String smsVerificationCode}) async {
    final AuthCredential credential = _getAuthCredentialFromVerificationCode(
        verificationId: verificationId, verificationCode: smsVerificationCode);
    return await authenticationWithCredential(credential: credential);
  }

  Future<User?> changeSMSVerificationCode(
      {required String verificationId,
        required String smsVerificationCode}) async {
    final PhoneAuthCredential credential = _getChangeAuthCredentialFromVerificationCode(
        verificationId: verificationId, verificationCode: smsVerificationCode);
    return await updateNumberWithCredential(credential: credential);
  }

  Future<User?> authenticationWithCredential(
      {required AuthCredential credential}) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future updateNumberWithCredential(
      {required PhoneAuthCredential credential}) async {
    await _firebaseAuth.currentUser!.updatePhoneNumber(credential);
  }

  AuthCredential _getAuthCredentialFromVerificationCode(
      {required String verificationId, required String verificationCode}) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
  }

  PhoneAuthCredential _getChangeAuthCredentialFromVerificationCode(
      {required String verificationId, required String verificationCode}) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
  }

  Future<PhoneAuthModel> verifyWithCredential({
    required AuthCredential credential,
  }) async {
    User? user = await authenticationWithCredential(
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

  Future<PhoneAuthModel> changeNumberWithCredential({
    required PhoneAuthCredential credential,
  }) async {
    User? user = await updateNumberWithCredential(
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

  Future<User?> createUser() async {
    final User? user = _firebaseAuth.currentUser;
    LocalDB.uid = user?.uid;
    LocalDB.phoneNumber = user?.phoneNumber;
    await Database.createOrUpdate(
        {'uid': LocalDB.uid, 'phoneNumber': LocalDB.phoneNumber});
  }
}
