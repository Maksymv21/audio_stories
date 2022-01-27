import 'package:equatable/equatable.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthNumberFailure extends PhoneAuthState {}

class PhoneAuthCodeFailure extends PhoneAuthState {}

class PhoneAuthNumberSuccess extends PhoneAuthState {
  final String verificationId;

  const PhoneAuthNumberSuccess({
    required this.verificationId,
  });

  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSuccess extends PhoneAuthState {
  final String? uid;

  const PhoneAuthCodeSuccess({
    required this.uid,
  });

  @override
  List<Object?> get props => [uid];
}
