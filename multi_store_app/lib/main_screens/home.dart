import 'package:flutter/material.dart';
import 'package:multi_store_app/galleries/accessories_gallery.dart';
import 'package:multi_store_app/galleries/bags_gallery.dart';
import 'package:multi_store_app/galleries/beauty_gallery.dart';
import 'package:multi_store_app/galleries/electronics_gallery.dart';
import 'package:multi_store_app/galleries/homegarden_gallery.dart';
import 'package:multi_store_app/galleries/kids_gallery.dart';
import 'package:multi_store_app/galleries/men_gallery.dart';
import 'package:multi_store_app/galleries/shoes_gallery.dart';
import 'package:multi_store_app/galleries/women_gallery.dart';
import 'package:multi_store_app/widgets/repeated_tabs.dart';
import 'package:multi_store_app/widgets/search_cont.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.withOpacity(0.3),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // title: const CupertinoSearchTextField(), for searchbar
          title: const SearchCont(),
          bottom: TabBar(
              isScrollable: true,
              tabAlignment:
                  TabAlignment.start, // Remove offset 0f 52px from left side
              indicatorColor: Colors.yellow,
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(color: Colors.yellow, width: 10),
                borderRadius:
                    BorderRadius.circular(1), // Adjust the radius as needed
              ),
              indicatorWeight: 6,
              tabs: const [
                RepeatedTab(label: 'Men'),
                RepeatedTab(label: 'Women'),
                RepeatedTab(label: 'Shoes'),
                RepeatedTab(label: 'Bags'),
                RepeatedTab(label: 'Electronics'),
                RepeatedTab(label: 'Accessories'),
                RepeatedTab(label: 'Home & Garden'),
                RepeatedTab(label: 'Kids'),
                RepeatedTab(label: 'Beauty'),
              ]),
        ),
        body: const TabBarView(children: [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          ShoesGalleryScreen(),
          BagsGalleryScreen(),
          ElectronicsGalleryScreen(),
          AccessoriesGalleryScreen(),
          HomeGardenGalleryScreen(),
          KidsGalleryScreen(),
          BeautyGalleryScreen(),
        ]),
      ),
    );
  }
}
