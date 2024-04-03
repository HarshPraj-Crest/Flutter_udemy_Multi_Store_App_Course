import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';

class SuppBalance extends StatelessWidget {
  const SuppBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        double totalPrice = 0.0;
        for (var item in snapshot.data!.docs) {
          totalPrice += item['orderqty'] * item['orderprice'];
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Statics'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StaticsModal(
                  label: 'Total Balance',
                  value: totalPrice,
                  decimal: 2,
                ),
                const SizedBox(height: 100),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade500,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: const Text(
                      'Get My Money !',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StaticsModal extends StatelessWidget {
  const StaticsModal({
    super.key,
    required this.label,
    required this.value,
    required this.decimal,
  });

  final String label;
  final dynamic value;
  final int decimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: AnimatedCounter(
            count: value,
            decimal: decimal,
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.count,
    required this.decimal,
  });

  final dynamic count;
  final int decimal;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = _controller;
    setState(() {
      _animation = Tween(
        begin: _animation.value,
        end: widget.count,
      ).animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Text(
            _animation.value.toStringAsFixed(widget.decimal),
            style: GoogleFonts.adamina(
              color: Colors.pink,
              fontSize: 40,
            ),
          ),
        );
      },
    );
  }
}
