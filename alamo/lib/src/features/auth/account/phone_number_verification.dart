import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/sign_in/string_validators.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyPhoneNumberScreen extends ConsumerStatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  ConsumerState<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends ConsumerState<VerifyPhoneNumberScreen> with CodeAutoFill {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final PhoneNumberRegexValidator phoneValidator = PhoneNumberRegexValidator();

  bool codeSent = false;
  String? verificationId;
  String? otpCode;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      // Automatically fill the code into the TextField
      _codeController.text = code ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    // Start listening for SMS autofill
    listenForCode();
  }

  @override
  void dispose() {
    // Stop listening for SMS codes when the widget is disposed
    cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountScreenControllerProvider);
    final accountController = ref.read(accountScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Verificar número de teléfono')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Por favor, ingresa tu número de teléfono:'),
              const SizedBox(height: 16),
              // Phone Number Input Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Número de teléfono',
                  hintText: '+59812345678',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo no puede estar vacío';
                  } else if (!phoneValidator.isValid(value)) {
                    return 'Número de teléfono no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Button to send verification code
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Call controller method to send verification code
                          await accountController.verifyPhone(
                            phoneNumber: _phoneController.text,
                            onVerificationCompleted: (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Número verificado automáticamente')),
                              );
                            },
                            onCodeSent: (result) {
                              setState(() {
                                codeSent = true;
                                verificationId = result.verificationId;
                              });
                            },
                            onAutoRetrievalTimeout: (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tiempo de espera agotado para verificación automática')),
                              );
                            },
                            onVerificationFailed: (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error de verificación: ${result.errorMessage}')),
                              );
                            },
                          );
                        }
                      },
                child: state.isLoading ? const CircularProgressIndicator() : const Text('Enviar código de verificación'),
              ),
              const SizedBox(height: 16),
              // Conditionally show verification code input field
              if (codeSent)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ingrese el código que recibió:'),
                    const SizedBox(height: 16),
                    // Verification Code Input Field using PinFieldAutoFill for autofill support
                    PinFieldAutoFill(
                      controller: _codeController,
                      codeLength: 6,
                      onCodeChanged: (code) {
                        if (code?.length == 6) {
                          _codeController.text = code!;
                        }
                      },
                      decoration: UnderlineDecoration(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        colorBuilder: const FixedColorBuilder(Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Button to submit verification code
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final result = await accountController.verifyPhoneCode(
                                  verificationId: verificationId!,
                                  smsCode: _codeController.text,
                                );

                                if (result) {
                                  context.goNamed(
                                    AppRoute.account.name,
                                  );
                                }
                              }
                            },
                      child: state.isLoading ? const CircularProgressIndicator() : const Text('Verificar código'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
