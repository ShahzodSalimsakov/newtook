import 'package:flutter/material.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/pages/login/type_phone.dart';
import 'package:newtook/pages/orders/orders.dart';
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
          return const ApiClientIntroPage();
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
