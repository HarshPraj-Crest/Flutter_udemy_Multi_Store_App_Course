import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModal extends StatelessWidget {
  const SupplierOrderModal({
    super.key,
    required this.order,
  });

  final dynamic order;

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
                  child: Image.network(order['orderimage']),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['ordername'],
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
                              (order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (order['orderqty'].toString())),
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
              Text(order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name: ') + (order['name']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Phone No.: ') + (order['phone']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Email Address: ') + (order['email']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      ('Address: ') + (order['address']),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status: '),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          (order['paymentstatus']),
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
                          (order['deliverystatus']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Order Date: '),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          (DateFormat('dd-MM-yyyy')
                              .format(order['orderdate'].toDate())
                              .toString()),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade500,
                          ),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == 'delivered'
                        ? const Text('This order has already been delivered',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ))
                        : Row(
                            children: [
                              const Text(
                                ('Change Delivery Status To: '),
                                style: TextStyle(fontSize: 16),
                              ),
                              order['deliverystatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          dateFormat: 'dd-MM-yyyy',
                                          pickerTheme:
                                              const DateTimePickerTheme(
                                            itemHeight: 60,
                                            itemTextStyle: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          minDateTime: DateTime.now(),
                                          maxDateTime: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                          onConfirm:
                                              (dateTime, selectedIndex) async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order['orderid'])
                                                .update({
                                              'deliverystatus': 'shipping',
                                              'deliverydate': dateTime,
                                            });
                                          },
                                        );
                                      },
                                      child: const Text('Shipping ?'))
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered',
                                        });
                                      },
                                      child: const Text('Delivered ?'))
                            ],
                          ),
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
