import 'package:alamo/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Color backgroundColor;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color foregroundColor;
  final double? radius;
  final String? fontFamily;
  final double? fontSize;

  const PrimaryButton({
    super.key,
    this.text,
    this.isLoading = false,
    this.onPressed,
    this.child,
    this.backgroundColor = const Color(0xff1B1C41),
    this.foregroundColor = Colors.white,
    this.radius,
    this.fontFamily = 'Sofia Sanz', // Inicializa el nuevo parámetro
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Sizes.p48,
        child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 5.0),
                )),
                backgroundColor:
                    WidgetStateProperty.all<Color>(backgroundColor),
                foregroundColor:
                    WidgetStateProperty.all<Color>(foregroundColor)),
            onPressed: onPressed,
            child: isLoading
                ? const CircularProgressIndicator()
                : child ??
                    Text(
                      text ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                        color: foregroundColor,
                      ),
                    )));
  }
}
