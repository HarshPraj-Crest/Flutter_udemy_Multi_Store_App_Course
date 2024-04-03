import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.aDLaMDisplay(
        textStyle: const TextStyle(
          fontSize: 28,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}