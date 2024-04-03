import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/widgets_auth/update_password.dart';
import 'package:multi_store_app/customer_screens/address_book.dart';
import 'package:multi_store_app/customer_screens/customer_orders.dart';
import 'package:multi_store_app/customer_screens/customer_wishlist.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/providers/id_provider.dart';
import 'package:multi_store_app/widgets/my_alert_dialog.dart';
import 'package:multi_store_app/widgets/profile_header_label.dart';
import 'package:multi_store_app/widgets/profile_option_button.dart';
import 'package:multi_store_app/widgets/repeated_list_tile.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:multi_store_app/widgets/yellow_divider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    // required this.documentId,
  });

  // final String documentId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String documentId = '';
  late String docId;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  clearUserId() {
    context.read<IdProvider>().clearCustomerId();
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        setState(() {
          documentId = user.uid;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return documentId.isNotEmpty
        ? FutureBuilder<DocumentSnapshot>(
            future: FirebaseAuth.instance.currentUser!.isAnonymous
                ? anonymous.doc(documentId).get()
                : customers.doc(documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print("Error fetching user data: ${snapshot.error}");
                return Text("Error fetching user data: ${snapshot.error}");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Scaffold(
                  backgroundColor: Colors.grey.shade300,
                  body: Stack(
                    children: [
                      Container(
                        height: 230,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 255, 237, 74),
                              Color.fromRGBO(255, 247, 171, 1)
                            ],
                          ),
                        ),
                      ),
                      CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            centerTitle: true,
                            expandedHeight: 140,
                            pinned: true,
                            flexibleSpace: LayoutBuilder(
                              builder: (context, constraints) {
                                return FlexibleSpaceBar(
                                  title: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: constraints.biggest.height <= 120
                                        ? 1
                                        : 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                        top: 44,
                                        right: 58,
                                      ),
                                      child: const Text(
                                        'Account',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  background: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 255, 237, 74),
                                          Color.fromRGBO(255, 247, 171, 1)
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 25,
                                        left: 30,
                                      ),
                                      child: Row(
                                        children: [
                                          data['profileimage'] == ''
                                              ? const CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: AssetImage(
                                                      'images/inapp/guest.jpg'),
                                                )
                                              : CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      data['profileimage']),
                                                ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text(
                                              data['name'] == ''
                                                  ? 'Guest'.toUpperCase()
                                                  : data['name'].toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ProfileOptionButton(
                                        colorBack: Colors.black54,
                                        colorText: Colors.yellow,
                                        font: 24,
                                        text: 'Cart',
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CartScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      ProfileOptionButton(
                                        colorBack: Colors.yellow,
                                        colorText: Colors.black54,
                                        font: 20,
                                        text: 'Orders',
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CustomerOrders(),
                                            ),
                                          );
                                        },
                                      ),
                                      ProfileOptionButton(
                                        colorBack: Colors.black54,
                                        colorText: Colors.yellow,
                                        font: 20,
                                        text: 'Wishlist',
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CustomerWishlist(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.grey.shade300,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 150,
                                        child: Image(
                                          image: AssetImage(
                                              'images/inapp/logo.jpg'),
                                        ),
                                      ),
                                      const ProfileHeaderLabel(
                                          labelText: '  Account Info.  '),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 260,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              RepeatedListTile(
                                                title: 'Email Address',
                                                subtitle: data['email'] == ''
                                                    ? 'example@gmail.com'
                                                    : data['email'],
                                                icon: Icons.email,
                                              ),
                                              const YellowDivider(),
                                              RepeatedListTile(
                                                title: 'Phone No.',
                                                subtitle: data['phone'] == ''
                                                    ? '+ 11111'
                                                    : data['phone'],
                                                icon: Icons.phone,
                                              ),
                                              const YellowDivider(),
                                              RepeatedListTile(
                                                onPressed: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .isAnonymous
                                                    ? null
                                                    : () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const AddressBook()));
                                                      },
                                                title: 'Address',
                                                subtitle: userAddress(data),
                                                // data['address'] == ''
                                                //     ? 'Example: New York, USA'
                                                //     : data['address'],
                                                icon: Icons.location_pin,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const ProfileHeaderLabel(
                                          labelText: '  Account Settings  '),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 260,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              RepeatedListTile(
                                                title: 'Edit Profile',
                                                icon: Icons.edit,
                                                onPressed: () {},
                                              ),
                                              const YellowDivider(),
                                              RepeatedListTile(
                                                title: 'Change Password',
                                                icon: Icons.lock,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UpdatePassword()));
                                                },
                                              ),
                                              const YellowDivider(),
                                              RepeatedListTile(
                                                title: 'Logout',
                                                icon: Icons.logout,
                                                onPressed: () async {
                                                  MyAlertDialog.showMyDialog(
                                                    context: context,
                                                    title: 'Log Out',
                                                    content:
                                                        'Are you sure you want to logout ?',
                                                    tabNo: () {
                                                      Navigator.pop(context);
                                                    },
                                                    tabYes: () async {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();
                                                      clearUserId();
                                                      if (context.mounted) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                '/welcome_screen');
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          )
        : Scaffold(
            body: Center(
              child: YellowButton(
                  label: 'Log in',
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/welcome_screen');
                  },
                  width: 0.5),
            ),
          );
  }

  String userAddress(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous == true) {
      return 'Exa: New York';
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data['address'] == '') {
      return 'Set Your Address';
    }
    return data['address'];
  }
}
