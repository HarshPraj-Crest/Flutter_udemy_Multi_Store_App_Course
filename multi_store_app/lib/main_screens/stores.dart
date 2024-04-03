import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens.dart/visit_store.dart';
import 'package:multi_store_app/providers/following_provider.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Stores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('suppliers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final storeId = snapshot.data!.docs[index]['cid'];
                  final followingProvider =
                      Provider.of<FollowingProvider>(context);
                  final isFollowing = followingProvider.isFollowing(storeId);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VisitStore(
                            suppId: storeId,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 130,
                              width: 120,
                              child: Image.asset('images/inapp/store.jpg'),
                            ),
                            Positioned(
                              top: (140 - 60) / 2,
                              left: (120 - 200) / 2,
                              child: SizedBox(
                                height: 60,
                                width: 200,
                                child: Image.network(
                                    snapshot.data!.docs[index]['storelogo']),
                              ),
                            ),
                            // if (isFollowing) // Add a badge if following
                            //   Positioned(
                            //     top: 0,
                            //     right: 0,
                            //     child: Container(
                            //       padding: const EdgeInsets.all(4),
                            //       decoration: BoxDecoration(
                            //         color: Colors.green,
                            //         borderRadius: BorderRadius.circular(5),
                            //       ),
                            //       child: const Text(
                            //         'Following',
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 12,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                        Text(
                          snapshot.data!.docs[index]['storename'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No Stores'),
              );
            }
          },
        ),
      ),
    );
  }
}
