import 'package:flutter/material.dart';
import 'package:ms_supplier_app/categories/accessories_category.dart';
import 'package:ms_supplier_app/categories/bags_category.dart';
import 'package:ms_supplier_app/categories/beauty_category.dart';
import 'package:ms_supplier_app/categories/electronics_category.dart';
import 'package:ms_supplier_app/categories/homegarden_category.dart';
import 'package:ms_supplier_app/categories/kids_category.dart';
import 'package:ms_supplier_app/categories/men_category.dart';
import 'package:ms_supplier_app/categories/shoes_category.dart';
import 'package:ms_supplier_app/categories/women_category.dart';
import 'package:ms_supplier_app/widgets/search_cont.dart';

List<ItemData> items = [
  ItemData(label: 'Men'),
  ItemData(label: 'Women'),
  ItemData(label: 'Electronics'),
  ItemData(label: 'Accessories'),
  ItemData(label: 'Shoes'),
  ItemData(label: 'Home & Garden'),
  ItemData(label: 'Beauty'),
  ItemData(label: 'Kids'),
  ItemData(label: 'Bags'),
];

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const SearchCont(),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: sideNavigator(size),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: categoryView(size),
          ),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8, // 80 % height of screen
      width: size.width * 0.2, // 20 % width of screen

      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 250),
                curve: Curves.linear,
              );
              // for (var element in items) {
              //   element.isSelected = false;
              // }
              // setState(() {
              //   items[index].isSelected = true;
              // });
            },
            child: Container(
              color: items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              height: 100,
              child: Center(
                child: Text(items[index].label),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.8, // 80 % height of screen
      width: size.width * 0.8, // 80 % width of screen
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          ShoesCategory(),
          HomeGardenCategory(),
          BeautyCategory(),
          KidsCategory(),
          BagsCategory(),
        ],
      ),
    );
  }
}

class ItemData {
  String label;
  bool isSelected;

  ItemData({
    required this.label,
    this.isSelected = false,
  });
}
