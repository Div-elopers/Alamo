/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:alamo/src/features/auth/sign_in/google/google_sign_in_controller.dart';
import 'package:alamo/src/widgets/primary_button.dart';
import 'package:alamo/src/utils/async_value_ui.dart';

class AppleSignInScreen extends ConsumerStatefulWidget {
  const AppleSignInScreen({super.key});

  @override
  ConsumerState<AppleSignInScreen> createState() => _AppleSignInScreenState();
}

class _AppleSignInScreenState extends ConsumerState<AppleSignInScreen> {
  Future<void> _signInWithApple() async {
    try {
      // Solicita credenciales a Apple
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // Manejar el inicio de sesión con las credenciales obtenidas
      print(credential);
      // Aquí puedes agregar la lógica para manejar el inicio de sesión exitoso.
    } catch (error) {
      // Maneja el error si ocurre durante el inicio de sesión
      print(error);
    }
  }

  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      googleSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(googleSignInControllerProvider);

    return Center(
      child: PrimaryButton(
        isLoading: state
            .isLoading, // El botón muestra un spinner si está en estado de carga
        onPressed: state.isLoading
            ? null
            : _signInWithApple, // Deshabilita el botón si está cargando
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/apple.png',
              height: 24,
            ),
            const SizedBox(width: 8), // Espacio entre el logo y el texto
            const Text(
              'Continuar con Apple',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
