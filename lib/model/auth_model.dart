import 'dart:convert';

enum PhoneAuthModelState {
  codeSent,
  autoVerified,
  error,
  verified,
}

class PhoneAuthModel {
  final PhoneAuthModelState phoneAuthModelState;
  final String? verificationId;
  final int? verificationToken;
  final String? uid;

  PhoneAuthModel({
    required this.phoneAuthModelState,
    this.verificationId,
    this.verificationToken,
    this.uid,
  });

  PhoneAuthModel copyWith({
    PhoneAuthModelState? phoneAuthModelState,
    String? verificationId,
    int? verificationToken,
    String? uid,
  }) {
    return PhoneAuthModel(
      phoneAuthModelState: phoneAuthModelState ?? this.phoneAuthModelState,
      verificationId: verificationId ?? this.verificationId,
      verificationToken: verificationToken ?? this.verificationToken,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneAuthModelState': phoneAuthModelState.index,
      'verificationId': verificationId,
      'verificationToken': verificationToken,
      'uid': uid,
    };
  }

  factory PhoneAuthModel.fromMap(Map<String, dynamic>? map) {
    return PhoneAuthModel(
      phoneAuthModelState:
      PhoneAuthModelState.values[map?['phoneAuthModelState']],
      verificationId: map?['verificationId'],
      verificationToken: map?['verificationToken'],
      uid: map?['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneAuthModel.fromJson(String source) =>
      PhoneAuthModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PhoneAuthModel(phoneAuthModelState: $phoneAuthModelState, verificationId: $verificationId, verificationToken: $verificationToken, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneAuthModel &&
        other.phoneAuthModelState == phoneAuthModelState &&
        other.verificationId == verificationId &&
        other.verificationToken == verificationToken &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return phoneAuthModelState.hashCode ^
    verificationId.hashCode ^
    verificationToken.hashCode ^
    uid.hashCode;
  }
}