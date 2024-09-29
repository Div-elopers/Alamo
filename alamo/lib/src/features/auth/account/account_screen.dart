import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:alamo/src/widgets/action_text_button.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:alamo/src/widgets/verified.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading ? const CircularProgressIndicator() : Text('Cuenta'.hardcoded),
        actions: [
          ActionTextButton(
            text: 'Cerrar sesión'.hardcoded,
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Estás seguro?'.hardcoded,
                      cancelActionText: 'Cancelar'.hardcoded,
                      defaultActionText: 'Cerrar sesión'.hardcoded,
                    );
                    if (logout == true) {
                      ref.read(accountScreenControllerProvider.notifier).signOut();
                    }
                  },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: AccountScreenContents(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class AccountScreenContents extends ConsumerWidget {
  const AccountScreenContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider(ref.watch(authRepositoryProvider).currentUser!.uid)).value;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.uid,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        gapH16,
        Text(
          user.email ?? '',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        gapH16,

        user.emailVerified ? const VerifiedWidget(type: "Email") : const VerifyEmailWidget(),

        gapH16,

        // Check phone verification status
        user.phoneVerified ? const VerifiedWidget(type: "Phone") : const VerifyPhoneWidget(),
        //
        gapH16,
        TextButton(
          onPressed: () async {
            final delete = await showAlertDialog(
              context: context,
              title: 'Estás seguro?'.hardcoded,
              cancelActionText: 'Cancelar'.hardcoded,
              defaultActionText: 'Eliminar'.hardcoded,
            );
            if (delete == true) {
              ref.read(accountScreenControllerProvider.notifier).deleteAccount();
            }
          },
          child: Text('Eliminar cuenta'.hardcoded),
        ),
      ],
    );
  }
}

class VerifyEmailWidget extends ConsumerWidget {
  const VerifyEmailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);
    final accountScreenController = ref.read(accountScreenControllerProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: state.isLoading
              ? null
              : () async {
                  final success = await accountScreenController.sendEmailVerification();
                  if (context.mounted && success) {
                    showAlertDialog(
                      context: context,
                      title: "Enviado - revisa tu casilla de correo".hardcoded,
                    );
                  }
                },
          child: state.isLoading ? const CircularProgressIndicator() : Text("Verificar correo".hardcoded),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async {
            await accountScreenController.reloadUserAndSyncWithFirestore();
          },
        ),
      ],
    );
  }
}

class VerifyPhoneWidget extends ConsumerWidget {
  const VerifyPhoneWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    context.goNamed(
                      AppRoute.verifyPhone.name,
                    );
                  },
            child: Text("Verificar numero de telefono".hardcoded))
      ],
    );
  }
}
