import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/providers/cart_provider.dart';
import 'package:ms_customer_app/providers/provider_class.dart';
import 'package:ms_customer_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';

class WishListItems extends StatelessWidget {
  const WishListItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Consumer<Wish>(
        builder: (context, wish, child) {
          return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                              index < wish.getWishItems.length
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
                                  index < wish.getWishItems.length
                                      ? product.name
                                      : '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      index < wish.getWishItems.length
                                          ? product.price.toStringAsFixed(2)
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            context
                                                .read<Wish>()
                                                .removeItem(product);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever),
                                        ),
                                        const SizedBox(width: 10),
                                        context
                                                        .watch<Cart>()
                                                        .getItems
                                                        .firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .documentId ==
                                                              product
                                                                  .documentId,
                                                        ) !=
                                                    null ||
                                                product.qunty == 0
                                            ? const SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  context.read<Cart>().addItem(
                                                        Product(
                                                          documentId: product
                                                              .documentId,
                                                          name: product.name,
                                                          price: product.price,
                                                          qty: 1,
                                                          qunty: product.qunty,
                                                          imagesUrl:
                                                              product.imagesUrl,
                                                          suppId:
                                                              product.suppId,
                                                        ),
                                                      );
                                                },
                                                icon: const Icon(
                                                    Icons.add_shopping_cart),
                                              ),
                                      ],
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
          );
        },
      ),
    );
  }
}
