import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Para que el texto se muestre como contraseña
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _register();
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    // Aquí puedes manejar la lógica de registro
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Realiza validaciones o envía los datos a una API, etc.
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      print('Usuario registrado con éxito');
    } else {
      print('Por favor complete todos los campos');
    }
  }
}
