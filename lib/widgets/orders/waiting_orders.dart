import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:arryt/widgets/orders/listen_deleted_waiting_order.dart';
import 'package:arryt/widgets/orders/waiting_order_card.dart';

import '../../bloc/block_imports.dart';
import '../../helpers/api_graphql_provider.dart';
import '../../main.dart';
import '../../models/customer.dart';
import '../../models/order.dart';
import '../../models/order_next_button.dart';
import '../../models/order_status.dart';
import '../../models/terminals.dart';
import '../../models/waiting_order.dart';
import 'current_order_card.dart';

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
    var query = '''
      query {
        myNewOrders {
          id
          to_lat
          to_lon
          from_lat
          from_lon
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
            cancel
            finish
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
      QueryOptions(document: gql(query), fetchPolicy: FetchPolicy.noCache),
    );
    print(data.data?['myNewOrders']);
    // var store = await ObjectBoxStore.getStore();
    if (data.data?['myNewOrders'] != null) {
      List<WaitingOrderModel> orders = [];
      data.data?['myNewOrders'].forEach((order) {
        OrderStatus orderStatus = OrderStatus(
          identity: order['orders_order_status']['id'],
          name: order['orders_order_status']['name'],
          cancel: order['orders_order_status']['cancel'],
          finish: order['orders_order_status']['finish'],
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
        WaitingOrderModel orderModel = WaitingOrderModel.fromMap(order);
        orderModel.customer.target = customer;
        orderModel.terminal.target = terminals;
        orderModel.orderStatus.target = orderStatus;
        // if (order['next_buttons'] != null) {
        //   order['next_buttons'].forEach((button) {
        //     OrderNextButton orderNextButton = OrderNextButton.fromMap(button);
        //     orderModel.orderNextButton.add(orderNextButton);
        //   });
        // }
        orders.add(orderModel);
        print(orderStatus);
      });
      await objectBox.clearWaitingOrders();
      _controller.finishLoad(IndicatorResult.success);
      objectBox.addWaitingOrders(orders);
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
          return ApiGraphqlProvider(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListenDeletedCurrentOrders(),
              // ListenNewCurrentOrder(),
              ListenDeletedWaitingOrders(),
              Expanded(
                child: StreamBuilder<List<WaitingOrderModel>>(
                  stream: objectBox.getWaitingOrders(),
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
                            return WaitingOrderCard(
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
          ));
        }
      } else {
        return Text(AppLocalizations.of(context)!.you_are_not_courier,
            style: Theme.of(context).textTheme.headline6);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
