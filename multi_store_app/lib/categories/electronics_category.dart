import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/categoryHeader_name.dart';
import 'package:multi_store_app/widgets/slidebar.dart';
import 'package:multi_store_app/widgets/subcateg_model.dart';

class ElectronicsCategory extends StatelessWidget {
  const ElectronicsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryHeaderName(
                    headerName: 'Electronics',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(electronics.length - 1, (index) {
                        return SubCategModel(
                          mainCategName: 'Electronics',
                          subCategName: electronics[index + 1],
                          assetName: 'images/electronics/electronics$index.jpg',
                          subCategLabel: electronics[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
         const SliderBar(subCategoryName: 'Electronics'),
        ],
      ),
    );
  }
}

