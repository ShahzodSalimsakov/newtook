import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              title: Text(AppLocalizations.of(context)!.orders.toUpperCase(),
                  style: const TextStyle(color: Colors.black)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              primary: true,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(50),
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
