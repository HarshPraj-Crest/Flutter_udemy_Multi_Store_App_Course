import 'package:flutter/material.dart';
import 'package:ms_supplier_app/utilities/categ_list.dart';
import 'package:ms_supplier_app/widgets/categoryheader_name.dart';
import 'package:ms_supplier_app/widgets/slidebar.dart';
import 'package:ms_supplier_app/widgets/subcateg_model.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({super.key});

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
                    headerName: 'Men',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      children: List.generate(men.length - 1, (index) {
                        return SubCategModel(
                          mainCategName: 'Men',
                          subCategName: men[index + 1],
                          assetName: 'images/men/men$index.jpg',
                          subCategLabel: men[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
         const SliderBar(subCategoryName: 'Men'),
        ],
      ),
    );
  }
}

