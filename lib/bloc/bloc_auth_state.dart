import 'package:equatable/equatable.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {}

class PhoneAuthNumberVerificationFailure extends PhoneAuthState {
  final String message;

  const PhoneAuthNumberVerificationFailure(this.message);

  @override
  List<Object> get props => [props];
}

class PhoneAuthNumberVerificationSuccess extends PhoneAuthState {
  final String verificationId;

  const PhoneAuthNumberVerificationSuccess({
    required this.verificationId,
  });

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSentSuccess extends PhoneAuthState {
  final String verificationId;

  const PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeVerificationFailure extends PhoneAuthState {
  final String message;
  final String verificationId;

  const PhoneAuthCodeVerificationFailure(this.message, this.verificationId);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeVerificationSuccess extends PhoneAuthState {
  final String? uid;

  const PhoneAuthCodeVerificationSuccess({
    required this.uid,
  });

  @override
  List<Object?> get props => [uid];
}

class PhoneAuthCodeAutoReturnTimeoutComplete extends PhoneAuthState {
  final String verificationId;

  const PhoneAuthCodeAutoReturnTimeoutComplete(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class RepeatPhoneAuth extends PhoneAuthState {}
