import 'package:flutter/material.dart';
import 'package:arryt/bloc/block_imports.dart';
import 'package:arryt/pages/login/type_phone.dart';
import 'package:arryt/pages/orders/orders.dart';
import 'api_client_intro/api_client_choose_brand.dart';
import 'api_client_intro/api_client_intro.dart';
import 'home/view/home_page.dart';

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
        builder: (context, apiState) {
      return BlocBuilder<UserDataBloc, UserDataState>(
          builder: (context, userDataState) {
        print(apiState.apiClients);
        if (apiState.apiClients.isEmpty) {
          return const ApiClientChooseBrand();
        } else {
          var accessToken = userDataState.accessToken;
          if (accessToken != null && accessToken.isNotEmpty) {
            return const HomePage();
          } else {
            return LoginTypePhonePage();
          }
          // return const Center(child: Text('Initial Page'));
        }
      });
    });
  }
}
