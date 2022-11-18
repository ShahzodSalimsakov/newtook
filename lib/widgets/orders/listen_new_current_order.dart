import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:arryt/main.dart';

import '../../bloc/block_imports.dart';
import '../../models/customer.dart';
import '../../models/order.dart';
import '../../models/order_next_button.dart';
import '../../models/order_status.dart';
import '../../models/terminals.dart';

final subscriptionDocument = gql(
  r'''
    subscription addedNewCurrentOrder($courier_id: String!) {
      addedNewCurrentOrder(courier_id: $courier_id) {
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
          }
          orders_terminals {
            id
            name
          }
          orders_order_status {
            id
            name
            finish
            cancel
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
  ''',
);

class ListenNewCurrentOrder extends StatelessWidget {
  const ListenNewCurrentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        return Subscription(
            options:
                SubscriptionOptions(document: subscriptionDocument, variables: {
              'courier_id': state.userProfile!.id,
            }),
            builder: (result) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (!result.isLoading && result.data != null) {
                print(result.data);
                if (result.data?['addedNewCurrentOrder'] != null) {
                  OrderStatus orderStatus = OrderStatus(
                    identity: result.data?['addedNewCurrentOrder']
                        ['orders_order_status']['id'],
                    name: result.data?['addedNewCurrentOrder']
                        ['orders_order_status']['name'],
                    cancel: result.data?['addedNewCurrentOrder']
                        ['orders_order_status']['cancel'],
                    finish: result.data?['addedNewCurrentOrder']
                        ['orders_order_status']['finish'],
                  );
                  Terminals terminals = Terminals(
                    identity: result.data?['addedNewCurrentOrder']
                        ['orders_terminals']['id'],
                    name: result.data?['addedNewCurrentOrder']
                        ['orders_terminals']['name'],
                  );
                  Customer customer = Customer(
                    identity: result.data?['addedNewCurrentOrder']
                        ['orders_customers']['id'],
                    name: result.data?['addedNewCurrentOrder']
                        ['orders_customers']['name'],
                    phone: result.data?['addedNewCurrentOrder']
                        ['orders_customers']['phone'],
                  );
                  OrderModel orderModel =
                      OrderModel.fromMap(result.data?['addedNewCurrentOrder']);
                  orderModel.customer.target = customer;
                  orderModel.terminal.target = terminals;
                  orderModel.orderStatus.target = orderStatus;
                  if (result.data?['addedNewCurrentOrder']['next_buttons'] !=
                      null) {
                    result.data?['addedNewCurrentOrder']['next_buttons']
                        .forEach((button) {
                      OrderNextButton orderNextButton =
                          OrderNextButton.fromMap(button);
                      orderModel.orderNextButton.add(orderNextButton);
                    });
                  }
                  objectBox.addCurrentOrders([orderModel]);
                }
              }
              // ResultAccumulator is a provided helper widget for collating subscription results.
              // careful though! It is stateful and will discard your results if the state is disposed
              return SizedBox();
            });
      },
    );
  }
}
