import 'package:flutter/material.dart';

const style = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  letterSpacing: 10,
);

class SliderBar extends StatelessWidget {
  const SliderBar({super.key, required this.subCategoryName});

  final String subCategoryName;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width * 0.05,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: RotatedBox(
              // To rotate direction of container to bottom to top
              quarterTurns: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  subCategoryName == 'Bags'
                      ? const Text('')
                      : const Text(' << ', style: style),
                  Text(subCategoryName.toUpperCase(), style: style),
                  subCategoryName == 'Men'
                      ? const Text('')
                      : const Text(' >> ', style: style),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
