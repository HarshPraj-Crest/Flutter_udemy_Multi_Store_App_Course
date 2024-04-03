import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/categoryHeader_name.dart';
import 'package:multi_store_app/widgets/slidebar.dart';
import 'package:multi_store_app/widgets/subcateg_model.dart';

class KidsCategory extends StatelessWidget {
  const KidsCategory({super.key});

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
                    headerName: 'Kids',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(kids.length - 1, (index) {
                        return SubCategModel(
                          mainCategName: 'Kids',
                          subCategName: kids[index + 1],
                          assetName: 'images/kids/kids$index.jpg',
                          subCategLabel: kids[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
         const SliderBar(subCategoryName: 'Kids'),
        ],
      ),
    );
  }
}

