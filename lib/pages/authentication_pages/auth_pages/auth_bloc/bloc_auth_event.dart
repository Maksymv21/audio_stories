import 'package:equatable/equatable.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneAuthNumberVerified extends PhoneAuthEvent {
  final String phoneNumber;

  const PhoneAuthNumberVerified({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthVerificationFailed extends PhoneAuthEvent {
  final String message;

  const PhoneAuthVerificationFailed(this.message);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeSent extends PhoneAuthEvent {
  final String verificationId;
  final int? token;

  const PhoneAuthCodeSent({
    required this.verificationId,
    required this.token,
  });

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeVerified extends PhoneAuthEvent {
  final String verificationId;
  final String smsCode;

  const PhoneAuthCodeVerified({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class ChangeAuthCodeVerified extends PhoneAuthEvent {
  final String verificationId;
  final String smsCode;

  const ChangeAuthCodeVerified({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class PhoneAuthCodeAutoReturnTimeout extends PhoneAuthEvent {
  final String verificationId;

  const PhoneAuthCodeAutoReturnTimeout(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthVerificationCompleted extends PhoneAuthEvent {
  final String? uid;

  const PhoneAuthVerificationCompleted(this.uid);

  @override
  List<Object?> get props => [uid];
}




