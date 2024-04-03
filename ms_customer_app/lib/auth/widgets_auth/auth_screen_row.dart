import 'package:flutter/material.dart';

class AuthScreenRow extends StatelessWidget {
  const AuthScreenRow({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/welcome_screen');
            },
            icon: const Icon(
              Icons.home_work,
              color: Colors.black,
            ),
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}
