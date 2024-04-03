import 'package:flutter/material.dart';

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.blueGrey.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
