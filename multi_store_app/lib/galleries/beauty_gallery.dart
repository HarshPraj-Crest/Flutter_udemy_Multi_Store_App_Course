import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class BeautyGalleryScreen extends StatefulWidget {
  const BeautyGalleryScreen({super.key});

  @override
  State<BeautyGalleryScreen> createState() => _BeautyGalleryScreenState();
}

class _BeautyGalleryScreenState extends State<BeautyGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'beauty')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    );
  }
}


