import 'package:alamo/src/widgets/primary_button.dart';
import 'package:alamo/src/widgets/responsive_scrollable_card.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

// Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repitepassController = TextEditingController();
  // Clave para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Registro de usuario',
            style: TextStyle(
              color: Color(0xff1B1C41), // Color del texto
              fontSize: 20, // Tamaño del texto
              fontFamily: 'Sofia Sanz',
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Establece el fondo transparente
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff1B1C41)),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios), // Cambia esto por tu icono personalizado
          color: const Color(0xff1B1C41),
          iconSize: 20, // Tamaño del icono
          onPressed: () {
            Navigator.of(context).pop(); // Navega hacia atrás
          },
        ),
      ),
      body: ResponsiveScrollableCard(
        child: FocusScope(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20), // Espacio superior
                  // Campo de nombre
                  const Text('Nombre'),
                  const SizedBox(height: 8), // Espacio entre texto y campo
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      // labelText: 'Nombre',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Campo de correo
                  const Text('Correo Electrónico'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      //labelText: 'Correo Electrónico',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Campo de contraseña
                  const Text('Contraseña'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      //labelText: 'Contraseña',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  /*ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register(); // Lógica de registro
                    }
                  },
                  child: const Text('Registrarse'),
                ),*/
                  PrimaryButton(
                    text:
                        'Registrarse', // Asegúrate de que este texto sea el adecuado
                    backgroundColor: const Color(0xff1B1C41),
                    isLoading:
                        _isLoading, // Aquí puedes manejar el estado de carga
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _register(); // Lógica de registro
                            }
                          },
                  ),
                ]),
          ),
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
    print('Usuario registrado: $name, Correo: $email');
  }
}
