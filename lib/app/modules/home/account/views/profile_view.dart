import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileMenu({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 18)),
          onTap: onTap,
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      ],
    );
  }
}
