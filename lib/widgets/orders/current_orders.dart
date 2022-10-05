import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newtook/models/order_status.dart';
import 'package:newtook/models/terminals.dart';

import '../../main.dart';
import '../../models/customer.dart';
import '../../models/order.dart';

class MyCurrentOrdersList extends StatelessWidget {
  const MyCurrentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(child: const MyCurrentOrderListView());
  }
}

class MyCurrentOrderListView extends StatefulWidget {
  const MyCurrentOrderListView({super.key});

  @override
  State<MyCurrentOrderListView> createState() => _MyCurrentOrderListViewState();
}

class _MyCurrentOrderListViewState extends State<MyCurrentOrderListView> {
  Future<void> _loadOrders() async {
    UserDataBloc userDataBloc = context.read<UserDataBloc>();
    var client = GraphQLProvider.of(context).value;
    var query = r'''
      query {
        myCurrentOrders {
          id
          to_lat
          to_lon
          pre_distance
          order_number
          order_price
          delivery_price
          delivery_address
          delivery_comment
          created_at
          orders_customers {
            id
            name
            phone
          }
          orders_terminals {
            id
            name
          }
          orders_order_status {
            id
            name
          }
        }
      }
    ''';
    var data = await client.query(
      QueryOptions(document: gql(query)),
    );
    print(data.data?['myCurrentOrders']);
    // var store = await ObjectBoxStore.getStore();
    if (data.data?['myCurrentOrders'] != null) {
      List<OrderModel> orders = [];
      data.data?['myCurrentOrders'].forEach((order) {
        OrderStatus orderStatus = OrderStatus(
          identity: order['orders_order_status']['id'],
          name: order['orders_order_status']['name'],
        );
        Terminals terminals = Terminals(
          identity: order['orders_terminals']['id'],
          name: order['orders_terminals']['name'],
        );
        Customer customer = Customer(
          identity: order['orders_customers']['id'],
          name: order['orders_customers']['name'],
          phone: order['orders_customers']['phone'],
        );
        OrderModel orderModel = OrderModel.fromMap(order);
        orderModel.customer.target = customer;
        orderModel.terminal.target = terminals;
        orderModel.orderStatus.target = orderStatus;
        orders.add(orderModel);
        print(orderStatus);
      });
      objectBox.addCurrentOrders(orders);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
      if (state.roles != null &&
          state.roles!
              .any((element) => element.code == 'courier' && element.active)) {
        if (!state.is_online) {
          return Center(
              child: Column(
            children: const [
              Text('Вы не включили режим работы'),
              Text(
                  'Включите режим работы сверху в углу, чтобы принимать заказы'),
            ],
          ));
        } else {
          return StreamBuilder<List<OrderModel>>(
            stream: objectBox.getCurrentOrders(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title:
                            Text(snapshot.data![index].order_number.toString()),
                        subtitle:
                            Text(snapshot.data![index].delivery_address ?? ''),
                        trailing: Text(
                            snapshot.data![index].orderStatus.target!.name),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Заказов нет'));
              }
            },
          );
        }
      } else {
        return Text(AppLocalizations.of(context)!.you_are_not_courier,
            style: Theme.of(context).textTheme.headline6);
      }
    });
  }
}
