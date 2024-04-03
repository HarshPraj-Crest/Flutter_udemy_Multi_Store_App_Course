import 'package:flutter/material.dart';
import 'package:multi_store_app/models/empty_wishlist.dart';
import 'package:multi_store_app/models/wishlist_items.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';
import 'package:multi_store_app/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

class CustomerWishlist extends StatefulWidget {
  const CustomerWishlist({super.key});

  @override
  State<CustomerWishlist> createState() => _CustomerWishlistState();
}

class _CustomerWishlistState extends State<CustomerWishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Wishlist'),
        actions: [
          context.watch<Wish>().getWishItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Clear Wishlist',
                      content: 'Are you sure you want to clear wishlist ?',
                      tabNo: () {
                        Navigator.of(context).pop();
                      },
                      tabYes: () {
                        context.read<Wish>().clearWishlist();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
        ],
      ),
      body: Consumer<Wish>(
        builder: (context, wish, child) {
          if (wish.getWishItems.isEmpty) {
            return const EmptyWishList();
          } else {
            print('Cart items length: ${wish.getWishItems.length}');
            return const WishListItems();
          }
        },
      ),
    );
  }
}





Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const AppBarTitle(title: 'My Wishlist'),
    ),
    body: const Center(
      child: Text('My Wishlist'),
    ),
  );
}
