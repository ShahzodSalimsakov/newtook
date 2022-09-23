import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home/view/work_switch.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 120,
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.orders,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 35)),
                      const HomeViewWorkSwitch()
                    ]),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              primary: true,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Completed'),
                  ],
                ),
              )),
          body: const TabBarView(
            children: [
              Center(child: Text('Pending')),
              Center(child: Text('Completed')),
            ],
          ),
        ),
      ),
    ));
  }
}
