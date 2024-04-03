import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:ms_supplier_app/widgets/yellow_button.dart';

class CustomerOrderModal extends StatefulWidget {
  const CustomerOrderModal({
    super.key,
    required this.order,
  });

  final dynamic order;

  @override
  State<CustomerOrderModal> createState() => _CustomerOrderModalState();
}

class _CustomerOrderModalState extends State<CustomerOrderModal> {
  late double rate;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.yellow,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(
              maxHeight: 100,
              maxWidth: double.infinity,
            ),
            child: Row(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 80,
                    maxWidth: 80,
                  ),
                  child: Image.network(widget.order['orderimage']),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(('\$ ') +
                              (widget.order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (widget.order['orderqty'].toString())),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('See More...'),
              Text(widget.order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == 'delivered'
                    ? const Color.fromARGB(255, 168, 239, 171).withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name: ') + (widget.order['name']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Phone No.: ') + (widget.order['phone']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Email Address: ') + (widget.order['email']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Address: ') + (widget.order['address']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status: '),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          (widget.order['paymentstatus']),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Delivery Status: '),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          (widget.order['deliverystatus']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade500,
                          ),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date: ') +
                                (DateFormat('dd-MM-yyyy')
                                    .format(
                                        widget.order['deliverydate'].toDate())
                                    .toString()),
                            style: const TextStyle(fontSize: 16),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Material(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 150,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            onRatingUpdate: (value) {
                                              rate = value;
                                            },
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Enter your review',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.amber,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            onChanged: (value) {
                                              comment = value;
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              YellowButton(
                                                  label: 'Cancel',
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  width: 0.3),
                                              const SizedBox(width: 20),
                                              YellowButton(
                                                  label: 'Add Review',
                                                  onPressed: () async {
                                                    CollectionReference collRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget
                                                                .order['proid'])
                                                            .collection(
                                                                'review');

                                                    await collRef
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .set({
                                                      'cid': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'orderid': widget
                                                          .order['orderid'],
                                                      'name':
                                                          widget.order['name'],
                                                      'email':
                                                          widget.order['email'],
                                                      'rate': rate,
                                                      'comment': comment,
                                                      'profileimage':
                                                          widget.order[
                                                              'profileimage'],
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
                                                                    'orders')
                                                                .doc(widget
                                                                        .order[
                                                                    'orderid']);

                                                        transaction.update(
                                                            documentReference, {
                                                          'orderreview': true,
                                                        });
                                                      });
                                                    });
                                                    if (context.mounted) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  width: 0.3),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Write Review',
                              style: TextStyle(fontSize: 16),
                            ))
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
