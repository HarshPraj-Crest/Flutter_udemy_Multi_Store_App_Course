import 'package:flutter/material.dart';

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        color: Colors.yellow,
        thickness: 2,
      ),
    );
  }
}