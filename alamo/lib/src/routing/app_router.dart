import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/account/phone_number_verification.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/forgot_password_screen.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/sign_up_screen.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/sign_in_screen.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen.dart';
import 'package:alamo/src/features/home/home_screen.dart';
import 'package:alamo/src/features/library/presentation/library_screen.dart';
import 'package:alamo/src/features/map/presentation/map_screen.dart';
import 'package:alamo/src/routing/go_router_refresh_stream.dart';
import 'package:alamo/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum AppRoute {
  home,
  map,
  chatbot,
  account,
  signIn,
  signUp,
  verifyPhone,
  forgotPassword,
  register,
  library,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;

      if (isLoggedIn) {
        if (path == '/signIn' || path == '/signIn/signUp') {
          return '/';
        }
      } else {
        // Allow access to `/forgotPassword` without redirection to `/signIn`
        if (path == '/forgotPassword' || path == '/signIn/signUp') {
          return null;
        }
        return '/signIn';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: AccountScreen(),
            ),
            routes: [
              GoRoute(
                path: 'verify-code',
                name: AppRoute.verifyPhone.name,
                pageBuilder: (context, state) => const MaterialPage(
                  child: VerifyPhoneNumberScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'map',
            name: AppRoute.map.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: MapScreen(),
            ),
          ),
          GoRoute(
            path: 'chat/:userId',
            name: AppRoute.chatbot.name,
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return MaterialPage(
                child: ChatScreen(userId: userId),
              );
            },
          ),
          GoRoute(
            path: 'library',
            name: AppRoute.library.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: LibraryScreen(),
            ),
          )
        ],
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: 'signUp',
            name: AppRoute.signUp.name,
            pageBuilder: (context, state) => MaterialPage(child: SignUpScreen()),
          ),
        ],
      ),
      // Define `forgotPassword` as a top-level route
      GoRoute(
        path: '/forgotPassword',
        name: AppRoute.forgotPassword.name,
        pageBuilder: (context, state) => const MaterialPage(
          child: ForgotPasswordScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
