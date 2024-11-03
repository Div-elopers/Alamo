import 'package:flutter/material.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({
    super.key,
    required this.type,
  });

  final String type;
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.verified, color: Colors.green.shade600);
  }
}
