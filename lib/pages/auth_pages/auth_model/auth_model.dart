enum PhoneAuthModelState {
  codeSent,
  autoVerified,
  error,
  verified,
}

class PhoneAuthModel {
  final PhoneAuthModelState phoneAuthModelState;
  final String? verificationId;
  final String? uid;

  PhoneAuthModel({
    required this.phoneAuthModelState,
    this.verificationId,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneAuthModelState': phoneAuthModelState.index,
      'verificationId': verificationId,
      'uid': uid,
    };
  }

  factory PhoneAuthModel.fromMap(Map<String, dynamic>? map) {
    return PhoneAuthModel(
      phoneAuthModelState:
          PhoneAuthModelState.values[map?['phoneAuthModelState']],
      verificationId: map?['verificationId'],
      uid: map?['uid'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneAuthModel &&
        other.phoneAuthModelState == phoneAuthModelState &&
        other.verificationId == verificationId &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return phoneAuthModelState.hashCode ^
        verificationId.hashCode ^
        uid.hashCode;
  }
}
