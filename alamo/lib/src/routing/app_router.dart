import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_screen.dart';
import 'package:alamo/src/features/home/home_screen.dart';
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
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: HomeScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
