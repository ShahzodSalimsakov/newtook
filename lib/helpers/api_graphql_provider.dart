import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../bloc/block_imports.dart';
import '../pages/api_client_intro/api_client_intro.dart';

class ApiGraphqlProvider extends StatelessWidget {
  Widget child;
  ApiGraphqlProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ApiClientsBloc(),
        child: _ApiGraphqlProviderView(
          child: child,
        ));
  }
}

class _ApiGraphqlProviderView extends StatelessWidget {
  Widget child;
  _ApiGraphqlProviderView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiClientsBloc, ApiClientsState>(
        builder: (context, state) {
      if (state.apiClients.isEmpty) {
        return const ApiClientIntroPage();
      } else {
        // find the first api client that is service default
        final apiClient = state.apiClients.firstWhere(
            (element) => element.isServiceDefault == true,
            orElse: () => state.apiClients.first);
        if (apiClient == null) {
          return const ApiClientIntroPage();
        } else {
          final HttpLink httpLink = HttpLink(
            'https://${apiClient.apiUrl}/graphql',
          );
          ValueNotifier<GraphQLClient> client = ValueNotifier(
            GraphQLClient(
              link: httpLink,
              // The default store is the InMemoryStore, which does NOT persist to disk
              cache: GraphQLCache(store: HiveStore()),
            ),
          );
          return GraphQLProvider(
            client: client,
            child: child,
          );
        }
      }
    });
  }
}
