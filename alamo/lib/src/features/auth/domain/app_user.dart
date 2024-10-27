typedef UserID = String;

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.phoneVerified = false,
    required this.displayName,
  });

  final UserID uid;
  final String? email;
  final bool emailVerified;
  final String? phoneNumber;
  final bool phoneVerified;
  final String displayName;

  // Factory constructor to create an instance of AppUser from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: (json['uid']),
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      displayName: json['displayName'] as String? ?? "",
    );
  }

  // Method to convert an instance of AppUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'displayName': displayName,
    };
  }

  Future<void> sendEmailVerification() async {
    // Your email verification logic here
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.emailVerified == emailVerified &&
        other.phoneVerified == phoneVerified &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, emailVerified: $emailVerified, phoneVerified: $phoneVerified)';
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
