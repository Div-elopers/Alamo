import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';

import 'auth_repository_test.mocks.dart';
import 'auth_repository_test.mocks.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authRepository = AuthRepository(mockFirebaseAuth);
  });

  group('AuthRepository', () {
    test('signInWithEmailAndPassword should return UserCredential on success', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => mockUserCredential);

      final result = await authRepository.signInWithEmailAndPassword('test@example.com', 'password123');

      expect(result, isA<UserCredential>());
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password123')).called(1);
    });

    test('createUserWithEmailAndPassword should return UserCredential on success', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authRepository.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, isA<UserCredential>());
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: 'test@example.com', password: 'password123')).called(1);
    });

    test('sendPasswordResetEmail should call FirebaseAuth.sendPasswordResetEmail', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email'))).thenAnswer((_) async => Future.value());

      await authRepository.sendPasswordResetEmail('test@example.com');

      verify(mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com')).called(1);
    });

    test('signInWithGoogle should call Google Sign-In and FirebaseAuth.signInWithCredential', () async {
      // Add test setup and verification for Google Sign-In here.
    });

    test('deleteUser should call FirebaseAuth delete method', () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.delete()).thenAnswer((_) async => Future.value());

      await authRepository.deleteUser();

      verify(mockUser.delete()).called(1);
    });
  });
}
