typedef UserID = String;

/// Simple class representing the user UID and email.
class AppUser {
  final String uid;
  final String? email;
  final bool emailVerified;
  final bool phoneVerified;
  final String name;
  final String? phoneNumber;
  final String? department;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.name = "",
    this.phoneNumber,
    this.department,
    this.createdAt,
  });

  // Factory constructor to create an AppUser instance from JSON data
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      name: json['name'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  // Method to convert an instance of AppUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'name': name,
      'phoneNumber': phoneNumber,
      'department': department,
      'createdAt': createdAt?.toIso8601String(),
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
        other.name == name;
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
