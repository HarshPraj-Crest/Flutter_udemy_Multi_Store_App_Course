import 'package:flutter/material.dart';

class RepeatedListTile extends StatelessWidget {
  RepeatedListTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icon,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
      ),
    );
  }
}