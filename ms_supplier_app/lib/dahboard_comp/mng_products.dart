import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_supplier_app/models/product_model.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class MngProducts extends StatelessWidget {
  const MngProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Manage Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 3,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _productsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(3),
              child: StaggeredGridView.countBuilder(
                // physics: const NeverScrollableScrollPhysics(),
                // shrinkWrap: false,
                crossAxisCount: 2,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ProductModel(product: snapshot.data!.docs[index]);
                },
                staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
              ),
            );
          },
        ),
      ),
    );
  }
}
