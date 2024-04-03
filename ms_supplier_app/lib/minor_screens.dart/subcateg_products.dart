import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_supplier_app/models/product_model.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategProducts extends StatefulWidget {
  const SubCategProducts({
    super.key,
    required this.subCategName,
    required this.mainCategName,
    this.fromOnBoarding = false,
  });

  final String subCategName;
  final String mainCategName;
  final bool fromOnBoarding;

  @override
  State<SubCategProducts> createState() => _SubCategProductsState();
}

class _SubCategProductsState extends State<SubCategProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.mainCategName.toLowerCase())
        .where('subcateg', isEqualTo: widget.subCategName.toLowerCase())
        .snapshots();

    print('mainCategName: ${widget.mainCategName}');
    print('subCategName: ${widget.subCategName}');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: widget.subCategName),
        leading: widget.fromOnBoarding == true
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/customer_home');
                },
                icon: const Icon(Icons.arrow_back))
            : null,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
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
                return ProductModel(product: snapshot.data!.docs[index]);
              },
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            ),
          );
        },
      ),
    );
  }
}
