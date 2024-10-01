import 'package:alamo/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Primary button based on [ElevatedButton]. Useful for CTAs in the app.
class PrimaryButton extends StatelessWidget {
  /// Create a PrimaryButton.
  /// if [isLoading] is true, a loading indicator will be displayed instead of
  /// the text or child.
  const PrimaryButton(
      {super.key,
      this.text,
      this.isLoading = false,
      this.onPressed,
      this.child,
      this.backgroundColor = Colors.black,
      this.foregroundColor = Colors.white,
      this.radius = 5.0});

  final String? text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? radius;

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
            backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
            foregroundColor: WidgetStateProperty.all<Color>(foregroundColor)),
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : child ??
                Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
      ),
    );
  }
}
