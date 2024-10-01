import 'package:alamo/src/features/auth/sign_in/google/google_sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/widgets/primary_button.dart';
import 'package:alamo/src/utils/async_value_ui.dart';

class GoogleSignInScreen extends ConsumerStatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  ConsumerState<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends ConsumerState<GoogleSignInScreen> {
  Future<void> _signInWithGoogle() async {
    final controller = ref.read(googleSignInControllerProvider.notifier);
    await controller.submit();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      googleSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(googleSignInControllerProvider);
    return Center(
      child: PrimaryButton(
        isLoading: state.isLoading,
        backgroundColor: Colors.white,
        onPressed: state.isLoading ? null : _signInWithGoogle,
        child: Image.asset(
          'assets/images/google.png',
          height: 24,
        ),
      ),
    );
  }
}
