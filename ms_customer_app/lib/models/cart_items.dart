import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_customer_app/providers/cart_provider.dart';
import 'package:ms_customer_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index) {
                final product = cart.getItems[index];
                final isLastItem = index == cart.count- 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLastItem ? 100 : 8),
                  child: Card(
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                index < cart.getItems.length
                                    ? product.imagesUrl
                                    : 'images/inapp/logo.jpg',
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    index < cart.getItems.length ? product.name : '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey.shade700,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        index < cart.getItems.length
                                            ? product.price.toStringAsFixed(2)
                                            : '',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            product.qty == 1
                                                ? IconButton(
                                                    onPressed: () {
                                                      showCupertinoModalPopup<void>(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            CupertinoActionSheet(
                                                          title: const Text(
                                                            'Remove Item',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          message: const Text(
                                                            'Are you sure you want to remove this item ?',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          actions: <CupertinoActionSheetAction>[
                                                            CupertinoActionSheetAction(
                                                              isDefaultAction: true,
                                                              onPressed: () async {
                                                                context.read<Wish>().getWishItems.firstWhereOrNull(
                                                                      (element) => element.documentId == product.documentId,
                                                                    ) !=
                                                                        null
                                                                    ? context.read<Cart>().removeItem(product)
                                                                    : await context.read<Wish>().addWishItem(
                                                                        product.name,
                                                                        product.price,
                                                                        1,
                                                                        product.qunty,
                                                                        product.imagesUrl,
                                                                        product.documentId,
                                                                        product.suppId,
                                                                      );
                                                                if (context.mounted) {
                                                                  context.read<Cart>().removeItem(product);
                                                                  Navigator.of(context).pop();
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Move to Wishlist',
                                                                style: TextStyle(
                                                                  color: Colors.blueAccent,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                            CupertinoActionSheetAction(
                                                              onPressed: () {
                                                                context.read<Cart>().removeItem(product);
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                'Delete Item',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.blueAccent,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          cancelButton: TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_forever,
                                                      size: 18,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      cart.decreament(product);
                                                    },
                                                    icon: const Icon(
                                                      FontAwesomeIcons.minus,
                                                      size: 18,
                                                    ),
                                                  ),
                                            Text(
                                              product.qty.toString(),
                                              style: product.qty == product.qunty
                                                  ? GoogleFonts.alexandria(
                                                      fontSize: 20,
                                                      color: Colors.red,
                                                    )
                                                  : GoogleFonts.alexandria(
                                                      fontSize: 20,
                                                    ),
                                            ),
                                            IconButton(
                                              onPressed: product.qty == product.qunty
                                                  ? null
                                                  : () {
                                                      cart.increament(product);
                                                    },
                                              icon: const Icon(
                                                FontAwesomeIcons.plus,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
