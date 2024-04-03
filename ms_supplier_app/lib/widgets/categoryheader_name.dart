import 'package:flutter/material.dart';

class CategoryHeaderName extends StatelessWidget {
  const CategoryHeaderName({
    super.key,
    required this.headerName,
  });

  final String headerName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Text(
        headerName,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
