import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ms_supplier_app/dahboard_comp/edit_prof.dart';
import 'package:ms_supplier_app/dahboard_comp/mng_products.dart';
import 'package:ms_supplier_app/dahboard_comp/supp_balance.dart';
import 'package:ms_supplier_app/dahboard_comp/supp_orders.dart';
import 'package:ms_supplier_app/dahboard_comp/supp_statics.dart';
import 'package:ms_supplier_app/minor_screens.dart/visit_store.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';
import 'package:ms_supplier_app/widgets/my_alert_dialog.dart';

List<String> label = [
  'My Store',
  'Orders',
  'Edit Profile',
  'Manage Products',
  'Balance',
  'Statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
 VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SuppOrders(),
  const EditProf(),
  const MngProducts(),
  const SuppBalance(),
  const SuppStatics(),
];

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              MyAlertDialog.showMyDialog(
                context: context,
                title: 'Log Out',
                content: 'Are you sure you want to logout ?',
                tabNo: () {
                  Navigator.pop(context);
                },
                tabYes: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/supplier_login');
                  }
                },
              );
            },
            color: Colors.black,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(12),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
        children: List.generate(6, (index) {
          return InkWell(
            onTap: () {
               print(FirebaseAuth.instance.currentUser!.uid);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => pages[index],
                ),
              );
            },
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              color: Colors.blueGrey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      color: Colors.yellow,
                      size: 50,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
