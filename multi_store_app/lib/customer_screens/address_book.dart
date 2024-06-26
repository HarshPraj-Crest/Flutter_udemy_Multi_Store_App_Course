import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/customer_screens/add_address.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();

  Future defAddFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(documentReference, {'default': false});
    });
  }

  Future defAddTrue(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customer['addressid']);
      transaction.update(documentReference, {'default': true});
    });
  }

  Future updateProfile(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'address':
            '${customer['city']} - ${customer['state']} - ${customer['country']}',
        'phone': customer['phone'],
      });
    });
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'Please wait...', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Address Book'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: addressStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                      child: Center(child: CircularProgressIndicator()));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'No Address \n\n  stored yet !',
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey.shade700,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var customer = snapshot.data!.docs[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentReference docReference = FirebaseFirestore
                              .instance
                              .collection('customers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('address')
                              .doc(customer['addressid']);
                          transaction.delete(docReference);
                        });
                      },
                      child: GestureDetector(
                        onTap: () async {
                          showProgress();
                          for (var item in snapshot.data!.docs) {
                            await defAddFalse(item);
                          }

                          await defAddTrue(customer).whenComplete(() async {
                            await updateProfile(customer).whenComplete(
                                () => Navigator.of(context).pop());
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Card(
                            color: customer['default'] == true
                                ? Colors.yellow
                                : const Color.fromARGB(255, 255, 248, 177),
                            child: ListTile(
                              title: SizedBox(
                                height: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Name:  ${customer['firstname']} ${customer['lastname']}'),
                                    Text('Phone No.:  ${customer['phone']}'),
                                  ],
                                ),
                              ),
                              subtitle: SizedBox(
                                height: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'City/State:  ${customer['city']}, ${customer['state']}'),
                                    Text('Country:  ${customer['country']}'),
                                  ],
                                ),
                              ),
                              trailing: customer['default'] == true
                                  ? const Icon(Icons.home, color: Colors.brown)
                                  : const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(26),
            child: YellowButton(
                label: 'Add New Address',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddAddress()));
                },
                width: 0.8),
          )
        ],
      ),
    );
  }
}
