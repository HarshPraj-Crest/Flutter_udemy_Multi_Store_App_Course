import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/supplier_order_modal.dart';

class Preparing extends StatelessWidget {
  const Preparing({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'You have no \n\n active orders !',
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
              return SupplierOrderModal(
                order: snapshot.data!.docs[index],
              );
            },
          );
        },
      );
  }
}