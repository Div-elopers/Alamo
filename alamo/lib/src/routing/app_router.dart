import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/account/phone_number_verification.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/forgot_password_screen.dart';
import 'package:alamo/src/features/auth/sign_in/sign_in_screen.dart';
import 'package:alamo/src/features/home/home_screen.dart';
import 'package:alamo/src/features/map/presentation/map_screen.dart';
import 'package:alamo/src/routing/go_router_refresh_stream.dart';
import 'package:alamo/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(AppRoute.orders.name)
/// ```
enum AppRoute {
  home,
  map,
  chatbot,
  account,
  signIn,
  verifyPhone,
  forgotPassword,
}

/// returns the GoRouter instance that defines all the routes in the app
final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // * redirect logic based on the authentication state
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/signIn') {
          return '/';
        }
      } else {
        if (path == '/signIn/forgotPassword') {
          //no redirection
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
        ],
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: "forgotPassword",
            name: AppRoute.forgotPassword.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: ForgotPasswordScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
