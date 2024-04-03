import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  const YellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.width,
  });

  final String label;
  final Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(45),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}