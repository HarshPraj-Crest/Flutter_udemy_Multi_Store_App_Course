import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/minor_screens.dart/product_details.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        title: CupertinoSearchTextField(
          autofocus: true,
          backgroundColor: Colors.white,
          onChanged: (value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
      ),
      body: searchInput == ''
          ? Center(
              child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 3),
                borderRadius: BorderRadius.circular(35),
              ),
              child: 
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.search, size: 38),
                        SizedBox(width: 5),
                        Text(
                          'Search for any item ...',
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
            ))
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final result = snapshot.data!.docs.where(
                  (e) => e['prdname'.toLowerCase()].contains(
                    searchInput.toLowerCase(),
                  ),
                );

                return ListView(
                    children: result.map((e) => SearchModel(e: e)).toList());
              },
            ),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(proList: e)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image(
                        image: NetworkImage(e['prdimages'][0]),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        e['prdname'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        e['prddescp'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
