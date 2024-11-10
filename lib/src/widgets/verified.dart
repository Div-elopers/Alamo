import 'package:flutter/material.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.verified, color: Colors.green.shade600);
  }
}
