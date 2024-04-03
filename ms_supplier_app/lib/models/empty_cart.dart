import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 30),
          Material(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.of(context).pop()
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Continue shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
