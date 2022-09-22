import 'package:flutter/material.dart';

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
              backgroundColor: Colors.white,
              elevation: 0,
              primary: false,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0),
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
