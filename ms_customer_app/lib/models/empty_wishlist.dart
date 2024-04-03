import 'package:flutter/material.dart';

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Wishlist is Empty !',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}