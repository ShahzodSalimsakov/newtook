import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newtook/models/order_status.dart';
import 'package:newtook/models/terminals.dart';
import 'package:newtook/objectbox.g.dart';
import 'package:newtook/widgets/orders/listen_deleted_current_order.dart';

import '../../main.dart';
import '../../models/customer.dart';
import '../../models/order.dart';
import 'current_order_card.dart';

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
    return BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
      if (state.roles != null &&
          state.roles!
              .any((element) => element.code == 'courier' && element.active)) {
        if (!state.is_online) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!
                      .error_work_schedule_offline_title
                      .toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  AppLocalizations.of(context)!
                      .notice_torn_on_work_schedule_subtitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApiGraphqlProvider(child: ListenDeletedCurrentOrders()),
              Expanded(
                child: StreamBuilder<List<OrderModel>>(
                  stream: objectBox.getCurrentOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return EasyRefresh(
                        controller: _controller,
                        header: const BezierCircleHeader(),
                        onRefresh: () async {
                          await _loadOrders();
                          _controller.finishRefresh();
                          _controller.resetFooter();
                        },
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return CurrentOrderCard(
                                order: snapshot.data![index]);
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('Заказов нет'));
                    }
                  },
                ),
              ),
            ],
          );
        }
      } else {
        return Text(AppLocalizations.of(context)!.you_are_not_courier,
            style: Theme.of(context).textTheme.headline6);
      }
    });
  }
}
