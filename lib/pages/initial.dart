import 'package:flutter/material.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/pages/orders/orders.dart';
import 'api_client_intro/api_client_intro.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _InitialPageView();
  }
}

class _InitialPageView extends StatelessWidget {
  const _InitialPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiClientsBloc, ApiClientsState>(
        builder: (context, state) {
      print(state.apiClients);
      if (state.apiClients.isEmpty) {
        return const ApiClientIntroPage();
      } else {
        return const OrdersPage();
        // return const Center(child: Text('Initial Page'));
      }
    });
  }
}
