//import 'package:alamo/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: const Color(0xFFA4D4A6), // Color de fondo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Radio de borde
        ),
        minimumSize: const Size(121, 29), // Tamaño mínimo del botón
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black, // Color del texto
          fontSize: 14, // Tamaño del texto
        ),
      ),
    );
  }
}
