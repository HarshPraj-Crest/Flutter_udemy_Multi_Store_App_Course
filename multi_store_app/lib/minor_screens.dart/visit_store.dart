import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/minor_screens.dart/edit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/providers/following_provider.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStore extends StatefulWidget {
  const VisitStore({
    Key? key,
    required this.suppId,
  }) : super(key: key);

  final String suppId;

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  late FollowingProvider? followingProvider;
  List<String> subscriptionsList = [];
  String? customerId = '';

  @override
  void initState() {
    super.initState();
    customerId = FirebaseAuth.instance.currentUser?.uid;
    followingProvider = Provider.of<FollowingProvider>(context, listen: false);
    if (customerId != null) {
      _fetchSubscriptions();
    }
  }

  Future<void> _fetchSubscriptions() async {
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        subscriptionsList.clear();
        for (var doc in querySnapshot.docs) {
          subscriptionsList.add(doc['customer_id']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the following state for the current store ID
    final bool isFollowing =
        followingProvider?.isFollowing(widget.suppId) ?? false;
    CollectionReference users =
        FirebaseFirestore.instance.collection('suppliers');

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 120,
              flexibleSpace: data['coverimage'] == ''
                  ? Image.asset(
                      'images/inapp/coverimage.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data['coverimage'],
                      fit: BoxFit.cover,
                    ),
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.yellow),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                data['storename']?.toUpperCase() ?? '',
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        customerId == null
                            ? const SizedBox()
                            : data['cid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Center(
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditStore(data: data)),
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Edit'),
                                              Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.yellow,
                                                border: Border.all(
                                                  width: 3,
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Center(
                                              child: MaterialButton(
                                                onPressed: () {
                                                  String id = FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid;
                                                  if (!isFollowing) {
                                                    FirebaseMessaging.instance
                                                        .subscribeToTopic(
                                                            'storenotifc');
                                                    // If not following, add to following list
                                                    FirebaseFirestore.instance
                                                        .collection('suppliers')
                                                        .doc(widget.suppId)
                                                        .collection(
                                                            'subscriptions')
                                                        .doc(id)
                                                        .set({
                                                      'customer_id': id
                                                    }).then((_) {
                                                      // Set following state for this store
                                                      setState(() {
                                                        followingProvider
                                                            ?.setFollowing(
                                                                widget.suppId);
                                                      });
                                                    });
                                                  } else {
                                                    FirebaseMessaging.instance
                                                        .unsubscribeFromTopic(
                                                            'storenotifc');
                                                    // If already following, remove from following list
                                                    FirebaseFirestore.instance
                                                        .collection('suppliers')
                                                        .doc(widget.suppId)
                                                        .collection(
                                                            'subscriptions')
                                                        .doc(id)
                                                        .delete()
                                                        .then((_) {
                                                      // Set not following state for this store
                                                      setState(() {
                                                        followingProvider
                                                            ?.setNotFollowing(
                                                                widget.suppId);
                                                      });
                                                    });
                                                  }
                                                },
                                                // onPressed: () {
                                                //   setState(() {
                                                //     following = !following;
                                                //   });
                                                // },
                                                child: isFollowing
                                                    ? const Text('Following')
                                                    : const Text('FOLLOW'),
                                              ),
                                            ),
                                          ),
                                          isFollowing != true
                                              ? const SizedBox()
                                              : IconButton(
                                                  onPressed: () {
                                                    OpenSettings
                                                        .openNotificationSetting();
                                                  },
                                                  icon: const Icon(Icons
                                                      .edit_notifications_rounded)),
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 12,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'This Store \n\n  has no items yet !',
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

                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: StaggeredGridView.countBuilder(
                      // physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: false,
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed: () {},
              child: const Icon(
                size: 40,
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
