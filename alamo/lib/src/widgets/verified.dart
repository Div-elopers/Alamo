import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({
    super.key,
    required this.type,
  });

  final String type;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$type Verificado".hardcoded,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.green.shade600),
        ),
        const SizedBox(width: 8),
        Icon(Icons.check_circle, color: Colors.green.shade600),
      ],
    );
  }
}
