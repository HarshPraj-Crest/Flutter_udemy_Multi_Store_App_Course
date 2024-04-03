import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_customer_app/main_screens/cart.dart';
import 'package:ms_customer_app/minor_screens.dart/full_screen_images.dart';
import 'package:ms_customer_app/minor_screens.dart/visit_store.dart';
import 'package:ms_customer_app/models/product_model.dart';
import 'package:ms_customer_app/providers/cart_provider.dart';
import 'package:ms_customer_app/providers/provider_class.dart';
import 'package:ms_customer_app/providers/wish_provider.dart';
import 'package:ms_customer_app/widgets/product_details_header.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.proList,
  });

  final dynamic proList;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imageList = widget.proList['prdimages'];

  @override
  Widget build(BuildContext context) {
    var onSell = widget.proList['discount'];
    var discountPrice = ((1 - (onSell / 100)) * widget.proList['price']);

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'])
        .where('subcateg', isEqualTo: widget.proList['subcateg'])
        .snapshots();

    final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.proList['proid'])
        .collection('review')
        .snapshots();

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImages(imageList: imageList)));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            itemCount: imageList.length,
                            itemHeight: 350,
                            itemWidth: 350,
                            layout: SwiperLayout.TINDER,
                            pagination: const SwiperPagination(),
                            control: const SwiperControl(
                              iconNext: Icons.arrow_forward_ios,
                              iconPrevious: Icons.arrow_back_ios,
                            ),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imageList[index],
                                ),
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                        Positioned(
                            left: 8,
                            top: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade700,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  )),
                            )),
                        Positioned(
                            right: 8,
                            top: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade700,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['prdname'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'USD  ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red,
                                  ),
                                ),
                                onSell != 0
                                    ? Text(
                                        widget.proList['price']
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Text(
                                        widget.proList['price']
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                const SizedBox(width: 6),
                                onSell != 0
                                    ? Text(
                                        discountPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  context
                                              .read<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget.proList['proid']) !=
                                          null
                                      ? context.read<Wish>().removeWishItem(
                                          widget.proList['proid'])
                                      : context.read<Wish>().addWishItem(
                                            widget.proList['prdname'],
                                            onSell != 0
                                                ? discountPrice
                                                : widget.proList['price'],
                                            1,
                                            widget.proList['instock'],
                                            widget.proList['prdimages'],
                                            widget.proList['proid'],
                                            widget.proList['sid'],
                                          );
                                },
                                icon: context
                                            .watch<Wish>()
                                            .getWishItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.proList['proid']) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 30,
                                      )),
                          ],
                        ),
                        widget.proList['instock'] == 0
                            ? Text(
                                'This item is out of stock',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey.shade800,
                                ),
                              )
                            : Text(
                                (widget.proList['instock'].toString()) +
                                    (' pieces available in stock'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey.shade800,
                                ),
                              ),
                        const SizedBox(height: 5),
                        const ProductDetailsHeader(
                          label: '    Item Description    ',
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.proList['prddescp'],
                          textScaler: const TextScaler.linear(1.1),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ExpandableTheme(
                          data: const ExpandableThemeData(
                            iconColor: Colors.blue,
                            iconSize: 28,
                          ),
                          child: reviews(reviewsStream),
                        ),
                        const ProductDetailsHeader(
                          label: '    Similar Items    ',
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'This category \n\n  has no items yet !',
                              style: GoogleFonts.aDLaMDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey.shade700,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(3),
                          child: StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return ProductModel(
                                product: snapshot.data!.docs[index],
                              );
                            },
                            staggeredTileBuilder: (index) =>
                                const StaggeredTile.fit(1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.blueGrey.shade900,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  VisitStore(suppId: widget.proList['sid']),
                            ));
                          },
                          icon: const Icon(
                            Icons.store,
                            color: Colors.white,
                            size: 30,
                          )),
                      const SizedBox(width: 25),
                      badges.Badge(
                        showBadge: context.read<Cart>().getItems.isEmpty
                            ? false
                            : true,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.yellow,
                          padding: EdgeInsets.all(5),
                        ),
                        badgeAnimation: const badges.BadgeAnimation.slide(),
                        badgeContent: Text(
                          context.watch<Cart>().getItems.length.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                  YellowButton(
                      label: context.read<Cart>().getItems.firstWhereOrNull(
                                  (element) =>
                                      element.documentId ==
                                      widget.proList['proid']) !=
                              null
                          ? 'ADDED TO CART'
                          : 'ADD TO CART',
                      onPressed: () {
                        if (widget.proList['instock'] == 0) {
                          MyMessageHandler.showSnackbar(
                              _scaffoldKey, 'This item is out of stock');
                        } else if (context
                                .read<Cart>()
                                .getItems
                                .firstWhereOrNull((product) =>
                                    product.documentId ==
                                    widget.proList['proid']) !=
                            null) {
                          MyMessageHandler.showSnackbar(
                              _scaffoldKey, 'Item already in your cart');
                        } else {
                          context.read<Cart>().addItem(
                                Product(
                                  documentId: widget.proList['proid'],
                                  name: widget.proList['prdname'],
                                  price: onSell != 0
                                      ? discountPrice
                                      : widget.proList['price'],
                                  qty: 1,
                                  qunty:  widget.proList['instock'],
                                  imagesUrl: imageList.first,
                                  suppId: widget.proList['sid'],
                                ),
                              );
                        }
                      },
                      width: 0.50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
    header: const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Reviews',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    collapsed: SizedBox(height: 230, child: reviewsAll(reviewsStream)),
    expanded: reviewsAll(reviewsStream),
  );
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot2.data!.docs.isEmpty) {
        return Center(
            child: Text(
          'This item \n\n  has no reviews yet !',
          style: GoogleFonts.aDLaMDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade700,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ));
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot2.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(snapshot2.data!.docs[index]['profileimage']),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot2.data!.docs[index]['name']),
                Row(
                  children: [
                    Text(snapshot2.data!.docs[index]['rate'].toString()),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(snapshot2.data!.docs[index]['comment']),
          );
        },
      );
    },
  );
}
