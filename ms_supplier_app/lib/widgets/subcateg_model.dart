import 'package:flutter/material.dart';
import 'package:ms_supplier_app/minor_screens.dart/subcateg_products.dart';

class SubCategModel extends StatelessWidget {
  const SubCategModel({
    super.key,
    required this.mainCategName,
    required this.subCategName,
    required this.assetName,
    required this.subCategLabel,
  });

  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subCategLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubCategProducts(
              subCategName: subCategName,
              mainCategName: mainCategName,
            ),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage(assetName),
            ),
          ),
          Text(
            subCategLabel,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
