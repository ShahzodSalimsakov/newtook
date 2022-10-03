import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:newtook/models/order.dart';

import '../home/view/work_switch.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  bool checkCourier() {
    return true;
  }

  final subscriptionDocument = gql(
    r'''
    subscription orderUpdate($courierId: String!) {
      orderUpdate(courier_id: $courierId) {
        id
      }
    }
  ''',
  );

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
                      BlocBuilder<UserDataBloc, UserDataState>(
                        builder: (context, state) {
                          // if roles exist and courier role exists
                          // find role with code = courier
                          if (state.roles != null &&
                              state.roles!.any((element) =>
                                  element.code == 'courier' &&
                                  element.active)) {
                            return ApiGraphqlProvider(
                                child: const HomeViewWorkSwitch());
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
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
          body: TabBarView(
            children: [
              Center(
                  child: BlocBuilder<UserDataBloc, UserDataState>(
                builder: (context, state) => ApiGraphqlProvider(
                    child: Subscription(
                  options: SubscriptionOptions(
                    document: subscriptionDocument,
                    variables: {'courierId': state.userProfile?.id},
                  ),
                  builder: (result) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    // ResultAccumulator is a provided helper widget for collating subscription results.
                    // careful though! It is stateful and will discard your results if the state is disposed
                    return ResultAccumulator.appendUniqueEntries(
                      latest: result.data,
                      builder: (context, {results}) => ListView.builder(
                        itemCount: results?.length,
                        itemBuilder: (context, index) {
                          final item = results?[index] as Order;
                          return Text(item.id);
                        },
                      ),
                    );
                  },
                )),
              )),
              const Center(child: Text('Completed')),
            ],
          ),
        ),
      ),
    ));
  }
}
