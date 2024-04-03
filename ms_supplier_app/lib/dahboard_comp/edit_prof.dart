import 'package:flutter/material.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';

class EditProf extends StatelessWidget {
  const EditProf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile'),
      ),
    );
  }
}