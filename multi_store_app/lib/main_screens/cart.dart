import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens.dart/place_order.dart';
import 'package:multi_store_app/models/cart_items.dart';
import 'package:multi_store_app/models/empty_cart.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';
import 'package:multi_store_app/widgets/my_alert_dialog.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String documentId = '';

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Cart'),
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Clear Cart',
                      content: 'Are you sure you want to clear cart ?',
                      tabNo: () {
                        Navigator.of(context).pop();
                      },
                      tabYes: () {
                        context.read<Cart>().clearCart();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.getItems.isEmpty) {
            return const EmptyCart();
          } else {
            print('Cart items length: ${cart.getItems.length}');
            return const CartItems();
          }
        },
      ),
      bottomSheet: Container(
        height: 60,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Text(
                        'Total: \$ ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        total.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                total == 0.0
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Add Items to checkout',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : documentId == ''
                        ? YellowButton(
                            width: 0.45,
                            label: 'CHECK OUT',
                            onPressed: () {
                              logInDialog(context);
                            },
                          )
                        : YellowButton(
                            width: 0.45,
                            label: 'CHECK OUT',
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const PlaceOrderScreen()));
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logInDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Please log in'),
              content: const Text('You should be logged in to take an action'),
              actions: [
                CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();

                    }),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('log in'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed('/customer_login');
                    }),
              ],
            ));
  }
}
