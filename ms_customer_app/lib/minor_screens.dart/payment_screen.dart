import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ms_customer_app/providers/cart_provider.dart';
import 'package:ms_customer_app/providers/stripe_id.dart';
import 'package:ms_customer_app/widgets/appbar_title.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
  });

  final String name;
  final String address;
  final String phone;

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'Please wait...', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Material(
            color: Colors.grey.shade200,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  title: const AppBarTitle(title: 'Payment'),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  child: Column(
                    children: [
                      Container(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '${totalPaid.toStringAsFixed(2)} USD',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total order',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                  Text(
                                    '${totalPrice.toStringAsFixed(2)} USD',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipping Cost',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                  Text(
                                    '10.00 USD',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
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
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Cash on Delivery'),
                                subtitle: const Text('Pay cash at home'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Pay via Visa / Master Card'),
                                subtitle: const Row(
                                  children: [
                                    Icon(Icons.payment, color: Colors.blue),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(FontAwesomeIcons.ccMastercard,
                                          color: Colors.blue),
                                    ),
                                    Icon(FontAwesomeIcons.ccVisa,
                                        color: Colors.blue),
                                  ],
                                ),
                              ),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Pay via Paypal'),
                                subtitle: const Row(
                                  children: [
                                    Icon(FontAwesomeIcons.paypal,
                                        color: Colors.blue),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.ccPaypal,
                                        color: Colors.blue),
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
                bottomSheet: Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: YellowButton(
                      label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                      onPressed: () {
                        if (selectedValue == 1) {
                          showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Pay at Home ${totalPaid.toStringAsFixed(2)} \$',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 100),
                                          child: YellowButton(
                                            label:
                                                'Confirm ${totalPaid.toStringAsFixed(2)} \$',
                                            onPressed: () async {
                                              showProgress();
                                              for (var item in context
                                                  .read<Cart>()
                                                  .getItems) {
                                                CollectionReference orderRef =
                                                    FirebaseFirestore.instance
                                                        .collection('orders');
                                                orderId = const Uuid().v4();
                                                await orderRef
                                                    .doc(orderId)
                                                    .set({
                                                  'cid': data['cid'],
                                                  'name': widget.name,
                                                  'email': data['email'],
                                                  'address': widget.address,
                                                  'phone': widget.phone,
                                                  'profileimage':
                                                      data['profileimage'],
                                                  'sid': item.suppId,
                                                  'proid': item.documentId,
                                                  'orderid': orderId,
                                                  'ordername': item.name,
                                                  'orderimage': item.imagesUrl,
                                                  'orderqty': item.qty,
                                                  'orderprice':
                                                      item.qty * item.price,
                                                  'deliverystatus': 'preparing',
                                                  'deliverydate': '',
                                                  'orderdate': DateTime.now(),
                                                  'paymentstatus':
                                                      'cash on delivery',
                                                  'orderreview': false,
                                                }).whenComplete(() async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                    DocumentReference
                                                        documentReference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(item
                                                                .documentId);
                                                    DocumentSnapshot snapshot2 =
                                                        await transaction.get(
                                                            documentReference);
                                                    transaction.update(
                                                        documentReference, {
                                                      'instock':
                                                          snapshot2['instock'] -
                                                              item.qty
                                                    });
                                                  });
                                                });
                                              }
                                              context.read<Cart>().clearCart();
                                              Navigator.of(context).popUntil(
                                                  ModalRoute.withName(
                                                      '/customer_home'));
                                            },
                                            width: 0.9,
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                        } else if (selectedValue == 2) {
                          makePayment();
                        } else if (selectedValue == 3) {
                          print('Paypal');
                        }
                      },
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Map<String, dynamic>? paymentIntentData;

  void makePayment() async {
    // cretePaymentIntent
    // initPaymentSheet
    // displayPaymentSheet

    paymentIntentData = await createPaymentIntent();
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntentData!['client_secret'],
      applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
      googlePay: const PaymentSheetGooglePay(
        merchantCountryCode: 'US',
        testEnv: true,
      ),
      merchantDisplayName: 'ANNIE',
    ));

    await displayPaymentSheet();
  }

  createPaymentIntent() async {
    Map<String, dynamic> body = {
      'amount': '1200',
      'currency': 'USD',
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'content_type': "application/x-www-form-urlencoded",
        });
    return jsonDecode(response.body);
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(options: const PaymentSheetPresentOptions());
    } catch (e) {
      // Handle any errors that occur during payment sheet presentation
      print('Error presenting Payment Sheet: $e');
    }
  }
}
