typedef UserID = String;

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.phoneNumberVerified = false,
  });

  final UserID uid;
  final String? email;
  final bool emailVerified;
  final String? phoneNumber;
  final bool phoneNumberVerified;

  Future<void> sendEmailVerification() async {}

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser && other.uid == uid && other.email == email && other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, phoneNumber: $phoneNumber)';
}

enum PhoneVerificationStatus {
  codeSent,
  verificationCompleted,
  verificationFailed,
  autoRetrievalTimeout,
}

class PhoneVerificationResult {
  final PhoneVerificationStatus status;
  final String? verificationId;
  final int? resendToken;
  final String? errorMessage;

  PhoneVerificationResult({
    required this.status,
    this.verificationId,
    this.resendToken,
    this.errorMessage,
  });
}
