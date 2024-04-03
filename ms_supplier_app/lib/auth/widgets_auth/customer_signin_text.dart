import 'package:flutter/material.dart';

class CustomerSignInText extends StatelessWidget {
  const CustomerSignInText({
    super.key,
  });

 InputDecoration buildInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.purple,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.deepPurple,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can use buildInputDecoration here or in other parts of your widget.
    return const SizedBox.shrink(); // You need to return a valid Widget, even if it's an empty SizedBox
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$').hasMatch(this);
  }
}