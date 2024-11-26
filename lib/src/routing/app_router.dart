import 'dart:developer';

import 'package:alamo/src/features/auth/account/account_screen.dart';
import 'package:alamo/src/features/auth/account/phone_number_verification.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/forgot_password_screen.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/sign_up_screen.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/sign_in_screen.dart';
import 'package:alamo/src/features/backOffice/bo_home_screen.dart';
import 'package:alamo/src/features/backOffice/centers_management_screen.dart';
import 'package:alamo/src/features/backOffice/library_management_screen.dart';
import 'package:alamo/src/features/backOffice/user_management_screen.dart';
import 'package:alamo/src/features/chat/presentation/chat_screen.dart';
import 'package:alamo/src/features/home/home_screen.dart';
import 'package:alamo/src/features/library/presentation/library_screen.dart';
import 'package:alamo/src/features/map/presentation/map_screen.dart';
import 'package:alamo/src/routing/go_router_refresh_stream.dart';
import 'package:alamo/src/routing/not_found_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  backOffice,
  mapManagement,
  userManagement,
  libraryManagement
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/appHome',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;

      if (kIsWeb) {
        if (isLoggedIn) {
          if (path != '/forgotPassword' && !path.startsWith('/backOffice')) {
            return '/backOffice';
          }

          if (path == '/signIn' || path == '/signIn/signUp') {
            return '/backOffice';
          }
        } else {
          if (path == '/forgotPassword') {
            return null;
          }
          return '/signIn';
        }
      } else {
        // Mobile logic
        if (isLoggedIn) {
          if (path == '/signIn' || path == '/signIn/signUp' || path.contains("/backOffice")) {
            return '/appHome';
          }
        } else {
          if (path == '/forgotPassword' || path == '/signIn/signUp') {
            return null; // Allow access
          }
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
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
          pageBuilder: (context, state) {
            final String email = state.extra != null ? state.extra.toString() : "";
            return MaterialPage(
              child: ForgotPasswordScreen(
                userEmail: email,
              ),
            );
          }),

      GoRoute(
        path: '/appHome',
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
                  pageBuilder: (context, state) {
                    final String phone = state.extra.toString();
                    log(phone);
                    return MaterialPage(
                      child: VerifyPhoneNumberScreen(
                        phone: phone,
                      ),
                    );
                  }),
            ],
          ),
          GoRoute(
            path: 'map',
            name: AppRoute.map.name,
            builder: (context, state) => const MapScreen(),
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
            path: '/library',
            name: AppRoute.library.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: LibraryScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/backOffice',
        name: AppRoute.backOffice.name,
        builder: (context, state) => const BackOfficeHomeScreen(),
        routes: [
          GoRoute(
            path: '/mapManagement',
            name: AppRoute.mapManagement.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: HelpCenterCreationScreen(),
            ),
          ),
          GoRoute(
            path: '/userManagement',
            name: AppRoute.userManagement.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: UserManagementScreen(),
            ),
          ),
          GoRoute(
            path: '/libraryManagement',
            name: AppRoute.libraryManagement.name,
            pageBuilder: (context, state) => const MaterialPage(
              child: LibraryManagementScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
