import 'package:flutter/material.dart';

class AccountSwitch extends StatelessWidget {
  const AccountSwitch({
    super.key,
    required this.haveAccount,
    required this.actionLabel,
    required this.onPressed,
  });

  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style:
              const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

