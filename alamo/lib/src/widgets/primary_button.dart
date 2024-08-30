import 'package:alamo/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Primary button based on [ElevatedButton]. Useful for CTAs in the app.
class PrimaryButton extends StatelessWidget {
  /// Create a PrimaryButton.
  /// if [isLoading] is true, a loading indicator will be displayed instead of
  /// the text or child.
  const PrimaryButton({
    super.key,
    this.text,
    this.isLoading = false,
    this.onPressed,
    this.child,
  });

  final String? text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : child ??
                Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
      ),
    );
  }
}
