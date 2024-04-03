import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customer_screens/add_address.dart';
import 'package:multi_store_app/customer_screens/address_book.dart';
import 'package:multi_store_app/minor_screens.dart/payment_screen.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  late String name;
  late String address;
  late String phone;
  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return StreamBuilder<QuerySnapshot>(
      stream: _addressStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // if (snapshot.data!.docs.isEmpty) {
        //   return Material(
        //     child: Center(
        //         child: Text(
        //       'This category \n\n  has no items yet !',
        //       style: GoogleFonts.aDLaMDisplay(
        //         fontSize: 28,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.blueGrey.shade700,
        //         letterSpacing: 1.5,
        //       ),
        //       textAlign: TextAlign.center,
        //     )),
        //   );
        // }

        return Material(
          color: Colors.grey.shade200,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.grey.shade200,
                title: const AppBarTitle(title: 'Place Order'),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                child: Column(
                  children: [
                    snapshot.data!.docs.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddAddress()));
                            },
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                child: Center(
                                  child: Text('Please Add Address !',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey.shade700,
                                      )),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddressBook()));
                            },
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var customer = snapshot.data!.docs[index];
                                      name = customer['firstname'] +
                                          ' ' +
                                          customer['lastname'];
                                      address = customer['city'] +
                                          '-' +
                                          customer['state'] +
                                          '-' +
                                          customer['country'];
                                      phone = customer['phone'];

                                      return ListTile(
                                        title: SizedBox(
                                          height: 60,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Name:  ${customer['firstname']} ${customer['lastname']}'),
                                              Text(
                                                  'Phone No.:  ${customer['phone']}'),
                                            ],
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          height: 60,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'City/State:  ${customer['city']}, ${customer['state']}'),
                                              Text(
                                                  'Country:  ${customer['country']}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Consumer<Cart>(
                          builder: (context, cart, child) {
                            return ListView.builder(
                              itemCount: cart.count,
                              itemBuilder: (context, index) {
                                final order = cart.getItems[index];
                                return Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.3),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(
                                                15,
                                              )),
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(
                                                order.imagesUrl),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  order.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 4,
                                                    horizontal: 12,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        order.price
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'x ${order.qty.toString()}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: YellowButton(
                    label: 'Confirm ${totalPrice.toStringAsFixed(2)} USD',
                    onPressed: snapshot.data!.docs.isEmpty
                        ? () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddAddress()));
                          }
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                      name: name,
                                      address: address,
                                      phone: phone,
                                    )));
                          },
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
