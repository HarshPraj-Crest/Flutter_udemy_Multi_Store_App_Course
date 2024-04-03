import 'package:flutter/material.dart';

class ProfileOptionButton extends StatelessWidget {
  const ProfileOptionButton({
    super.key,
    required this.text,
    required this.colorBack,
    required this.colorText,
    required this.font,
    required this.onPressed,
  });

  final String text;
  final Color colorBack;
  final Color colorText;
  final double font;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorBack,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: colorText,
                fontSize: font,
              ),
            ),
          ),
        ),
      ),
    );
  }
}