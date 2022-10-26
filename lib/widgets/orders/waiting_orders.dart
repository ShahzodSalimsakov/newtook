import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../bloc/block_imports.dart';
import '../../helpers/api_graphql_provider.dart';
import '../../main.dart';
import '../../models/customer.dart';
import '../../models/order.dart';
import '../../models/order_next_button.dart';
import '../../models/order_status.dart';
import '../../models/terminals.dart';

class MyWaitingOrdersList extends StatelessWidget {
  const MyWaitingOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(child: const MyWaitingOrdersListView());
  }
}

class MyWaitingOrdersListView extends StatefulWidget {
  const MyWaitingOrdersListView({super.key});

  @override
  State<MyWaitingOrdersListView> createState() =>
      _MyWaitingOrdersListViewState();
}

class _MyWaitingOrdersListViewState extends State<MyWaitingOrdersListView>
    with AutomaticKeepAliveClientMixin<MyWaitingOrdersListView> {
  late EasyRefreshController _controller;

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
          next_buttons {
            name
            id
            color
            sort
            finish
            waiting
            cancel
          }
        }
      }
    ''';
    var data = await client.query(
      QueryOptions(document: gql(query), fetchPolicy: FetchPolicy.noCache),
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
        if (order['next_buttons'] != null) {
          order['next_buttons'].forEach((button) {
            OrderNextButton orderNextButton = OrderNextButton.fromMap(button);
            orderModel.orderNextButton.add(orderNextButton);
          });
        }
        orders.add(orderModel);
        print(orderStatus);
      });
      await objectBox.clearCurrentOrders();
      _controller.finishLoad(IndicatorResult.success);
      objectBox.addCurrentOrders(orders);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
