import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/main_screens/category.dart';
import 'package:multi_store_app/main_screens/home.dart';
import 'package:multi_store_app/main_screens/profile.dart';
import 'package:multi_store_app/main_screens/stores.dart';
import 'package:badges/badges.dart' as badges;
import 'package:multi_store_app/minor_screens.dart/visit_store.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:multi_store_app/services/notifications.dart';
import 'package:provider/provider.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const Home(),
    const Category(),
    const StoreScreen(),
    const CartScreen(),
    const ProfileScreen(
        // documentId: FirebaseAuth.instance.currentUser!.uid,
        ),
  ];

  displayForegroundNotifications() {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationServices.displayNotification(message);
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'store') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              const VisitStore(suppId: "1BuRV2oAA7g9l0CL7W0nZU1iSco1")));
    }
  }

  @override
  void initState() {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('token : $value'));
    context.read<Cart>().loadCartItemsProvider();
    displayForegroundNotifications();
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      // appBar: AppBar(
      //   title: const Text("Customer Home Screen"),
      // ),
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
                showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.yellow,
                  padding: EdgeInsets.all(4),
                ),
                badgeAnimation: const badges.BadgeAnimation.slide(),
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Icon(Icons.shopping_cart)),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
