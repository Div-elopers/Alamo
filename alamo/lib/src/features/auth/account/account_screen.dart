import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:alamo/src/widgets/action_text_button.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:alamo/src/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
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
    final user = ref.watch(authStateChangesProvider).value;
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
        gapH32,
        Text(
          user.email ?? '',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        gapH16,
        EmailVerificationWidget(
          user: user,
        ),
      ],
    );
  }
}

class EmailVerificationWidget extends ConsumerWidget {
  const EmailVerificationWidget({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountScreenControllerProvider);
    if (user.emailVerified == false) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await ref.read(accountScreenControllerProvider.notifier).sendEmailVerification(user);
                      if (success && context.mounted) {
                        showAlertDialog(
                          context: context,
                          title: "Enviado - revisa tu casilla de correo".hardcoded,
                        );
                      }
                    },
              child: Text("Verificar correo".hardcoded))
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Verificado".hardcoded,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.green.shade600),
          ),
          gapW8,
          Icon(Icons.check_circle, color: Colors.green.shade600),
        ],
      );
    }
  }
}
