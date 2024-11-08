import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PopupMenuOption {
  signIn,
  map,
  account,
  chatBot,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key, this.user});
  final AppUser? user;

  // * Keys for testing using find.byKey()
  static const signInKey = Key('menuSignIn');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return <PopupMenuEntry<PopupMenuOption>>[
          if (user != null) ...[
            PopupMenuItem(
              key: accountKey,
              value: PopupMenuOption.account,
              child: Text('Cuenta'.hardcoded),
            ),
            PopupMenuItem(
              key: accountKey,
              value: PopupMenuOption.map,
              child: Text('Mapa'.hardcoded),
            ),
            PopupMenuItem(
              key: accountKey,
              value: PopupMenuOption.chatBot,
              child: Text('Chat'.hardcoded),
            ),
          ] else
            PopupMenuItem(
              key: signInKey,
              value: PopupMenuOption.signIn,
              child: Text('Iniciar Sesión'.hardcoded),
            ),
        ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signIn:
            context.goNamed(AppRoute.signIn.name);
          case PopupMenuOption.map:
            context.goNamed(AppRoute.map.name);
          case PopupMenuOption.account:
            context.goNamed(AppRoute.account.name);
          case PopupMenuOption.chatBot:
            context.goNamed(AppRoute.chatbot.name, pathParameters: {'userId': user!.uid});
        }
      },
    );
  }
}
