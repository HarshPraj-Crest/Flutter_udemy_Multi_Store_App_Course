import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_title.dart';

class SuppStore extends StatelessWidget {
  const SuppStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'My Store'),
      ),
      body: const Center(
        child: Text('My Store'),
      ),
    );
  }
}