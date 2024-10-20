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
  final TextEditingController _repitpassController = TextEditingController();
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
                color: Color(0xff1B1C41),
                fontSize: 20,
                fontFamily: 'Sofia Sans',
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xff1B1C41)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xff1B1C41),
            iconSize: 20,
            onPressed: () {
              Navigator.of(context).pop(); // Navega hacia atrás
            },
          ),
        ),
        body: SingleChildScrollView(
          child: ResponsiveScrollableCard(
            child: FocusScope(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //const SizedBox(height: 0), // Espacio superior
                      // Campo de nombre
                      const Text('Nombre'),
                      const SizedBox(height: 8), // Espacio entre texto y campo
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                      const Text('Telefono'),
                      const SizedBox(height: 8), // Espacio entre texto y campo
                      TextFormField(
                        controller: _telephoneController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu telefono';
                          }
                          return null;
                        },
                      ),
                      const Text('Departamento'),
                      const SizedBox(height: 8), // Espacio entre texto y campo
                      TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona un Departamento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo de correo
                      const Text('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          //labelText: 'Correo Electrónico',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu email';
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
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                      const SizedBox(height: 16),
                      // Campo de repetir contraseña
                      const Text('Repetir contraseña'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _repitpassController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la contraseña ingresada nuevamente';
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Al registrarse está de acuerdo con los términos y condiciones',
                          style: TextStyle(
                            fontFamily: 'Sofia Sans',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'Crear usuario',
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
        ));
  }

  void _register() {
    // Aquí puedes manejar la lógica de registro
    String name = _nameController.text;
    String tel = _telephoneController.text;
    String state = _stateController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String repitPass = _repitpassController.text;

    // Realiza validaciones o envía los datos a una API, etc.
    print('Usuario registrado: $name, Correo: $email');
  }
}
