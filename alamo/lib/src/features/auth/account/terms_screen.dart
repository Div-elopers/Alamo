import 'package:flutter/material.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Términos y condiciones'),
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(
        child: SizedBox(
          width: 390, // Ancho de 390px
          height: 844, // Altura de 844px
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Aquí van los términos y condiciones...',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              /* ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
