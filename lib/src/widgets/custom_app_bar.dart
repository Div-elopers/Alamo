import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFAFAFA),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'SofiaSans',
          fontSize: 20,
          color: Color(0xFF1B1C41),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.chevron_left,
            color: Color(0xFF1B1C41)), // Color del IconButton
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
