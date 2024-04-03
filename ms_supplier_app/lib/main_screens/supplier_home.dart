import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ms_supplier_app/main_screens/category.dart';
import 'package:ms_supplier_app/main_screens/dashboard.dart';
import 'package:ms_supplier_app/main_screens/home.dart';
import 'package:ms_supplier_app/main_screens/stores.dart';
import 'package:ms_supplier_app/main_screens/supp_upload.dart';
import 'package:ms_supplier_app/services/notifications.dart';
import 'package:badges/badges.dart' as badges;

class SupplierHome extends StatefulWidget {
  const SupplierHome({super.key});

  @override
  State<SupplierHome> createState() => _SupplierHomeHomeState();
}

class _SupplierHomeHomeState extends State<SupplierHome> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const Home(),
    const Category(),
    const StoreScreen(),
    Dashboard(),
    const SuppUploadScreen(),
  ];

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationServices.displayNotification(message);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliverystatus', isEqualTo: 'preparing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: _tabs[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            selectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Category',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Stores',
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                    showBadge: snapshot.data!.docs.isEmpty ? false : true,
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.yellow,
                      padding: EdgeInsets.all(4),
                    ),
                    badgeAnimation: const badges.BadgeAnimation.slide(),
                    badgeContent: Text(
                      snapshot.data!.docs.length.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Icon(Icons.dashboard)),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: 'Upload',
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
