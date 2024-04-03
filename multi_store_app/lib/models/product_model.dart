import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens.dart/edit_product.dart';
import 'package:multi_store_app/minor_screens.dart/product_details.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';

class ProductModel extends StatefulWidget {
  const ProductModel({
    super.key,
    required this.product,
  });

  final dynamic product;

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
      late List<dynamic> imageList = widget.product['prdimages'];


    var onSell = widget.product['discount'];

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(proList: widget.product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      constraints:
                          const BoxConstraints(minHeight: 100, maxHeight: 250),
                      child: Image(
                        image: NetworkImage(
                          widget.product['prdimages'][0],
                        ),
                      ),
                    ),
                    Text(
                      widget.product['prdname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('\$ ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                )),
                            Text(
                              widget.product['price'].toStringAsFixed(2),
                              style: onSell != 0
                                  ? const TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    )
                                  : const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                            ),
                            const SizedBox(width: 6),
                            onSell != 0
                                ? Text(
                                    ((1 - (onSell / 100)) *
                                            widget.product['price'])
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(''),
                          ],
                        ),
                                                                                                                                                   
                        // if (currentUser != null && )

                        widget.product['sid'] == currentUser?.uid && currentUser != null
                            ? IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditProduct(items: widget.product)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ))
                            : IconButton(
                                onPressed: () {
                                  context
                                              .read<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget.product['proid']) !=
                                          null
                                      ? context.read<Wish>().removeWishItem(
                                          widget.product['proid'])
                                      : context.read<Wish>().addWishItem(
                                            widget.product['prdname'],
                                            onSell != 0
                                                ? ((1 - (onSell / 100)) *
                                                    widget.product['price'])
                                                : widget.product['price'],
                                            1,
                                            widget.product['instock'],
                                            // widget.product['prdimages'],
                                            imageList.first,
                                            widget.product['proid'],
                                            widget.product['sid'],
                                          );
                                },
                                icon: context
                                            .watch<Wish>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.product['proid']) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 28,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 28,
                                      )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            widget.product['discount'] != 0
                ? Positioned(
                    top: 30,
                    left: 0,
                    child: Container(
                      height: 25,
                      width: 85,
                      decoration: const BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: Center(
                        child: Text(
                          'Save ${widget.product['discount'].toString()} %',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : Container(color: Colors.transparent),
          ],
        ),
      ),
    );
  }
}
