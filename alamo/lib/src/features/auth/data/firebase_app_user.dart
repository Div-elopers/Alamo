import 'package:firebase_auth/firebase_auth.dart';

import '../domain/app_user.dart';

class FirebaseAppUser implements AppUser {
  final User _user;
  const FirebaseAppUser(this._user);

  @override
  String? get email => _user.email;

  @override
  bool get emailVerified => _user.emailVerified;

  @override
  UserID get uid => _user.uid;

  @override
  Future<void> sendEmailVerification() => _user.sendEmailVerification();

  @override
  String? get phoneNumber => _user.phoneNumber;

  @override
  bool get phoneVerified => _user.phoneNumber != null && _user.phoneNumber!.isNotEmpty;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  String get displayName => throw UnimplementedError();
}
