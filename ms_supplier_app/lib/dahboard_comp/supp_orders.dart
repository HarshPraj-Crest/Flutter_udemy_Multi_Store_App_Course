import 'package:flutter/material.dart';
import 'package:ms_supplier_app/dahboard_comp/delivered_orders.dart';
import 'package:ms_supplier_app/dahboard_comp/preparing_orders.dart';
import 'package:ms_supplier_app/dahboard_comp/shipping_orders.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';

class SuppOrders extends StatelessWidget {
  const SuppOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Orders'),
          bottom: TabBar(
              indicatorColor: Colors.yellow,
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(color: Colors.yellow, width: 10),
                borderRadius:
                    BorderRadius.circular(1), // Adjust the radius as needed
              ),
              indicatorWeight: 6,
              tabs: const [
                RepeatedTab(label: 'Preparing'),
                RepeatedTab(label: 'Shipping'),
                RepeatedTab(label: 'Delivered'),
              ]),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  const RepeatedTab({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
