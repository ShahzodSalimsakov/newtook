import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:arryt/main.dart';
import 'package:arryt/models/order.dart';
import 'package:arryt/widgets/orders/orders_items.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/customer.dart';
import '../../models/order_next_button.dart';
import '../../models/order_status.dart';
import '../../models/organizations.dart';
import '../../models/terminals.dart';
import '../../models/waiting_order.dart';

class WaitingOrderCard extends StatefulWidget {
  final WaitingOrderModel order;
  const WaitingOrderCard({super.key, required this.order});

  @override
  State<WaitingOrderCard> createState() => _WaitingOrderCardState();
}

class _WaitingOrderCardState extends State<WaitingOrderCard> {
  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
    symbol: 'сум',
    symbolSide: SymbolSide.right,
    thousandSeparator: ' ',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  bool loading = false;

  Future<void> _approveOrder(String orderId) async {
    setState(() {
      loading = true;
    });

    var client = GraphQLProvider.of(context).value;
    var query = r'''
      mutation($orderId: String!) {
        approveOrder(orderId: $orderId) {
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
          payment_type
          orders_organization {
            id
            name
            icon_url
            active
            external_id
            support_chat_url
          }
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
            cancel
            finish
            on_way
            in_terminal
          }
          next_buttons {
            name
            id
            color
            sort
            finish
            waiting
            cancel
            on_way
            in_terminal
          }
        }
      }
    ''';
    var result = await client.mutate(MutationOptions(
        document: gql(query),
        variables: <String, dynamic>{
          'orderId': widget.order.identity,
        },
        fetchPolicy: FetchPolicy.noCache));
    if (result.hasException) {
      AnimatedSnackBar.material(
        result.exception?.graphqlErrors[0].message ?? "Error",
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print(result.exception);
    } else {
      AnimatedSnackBar.material(
        AppLocalizations.of(context)!.orderApprovedSuccessfully,
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print(result.data);
      if (result.data != null) {
        var order = result.data!['approveOrder'];
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
        Organizations organizations = Organizations(
            order['orders_organization']['id'],
            order['orders_organization']['name'],
            order['orders_organization']['active'],
            order['orders_organization']['icon_url'],
            order['orders_organization']['description'],
            order['orders_organization']['max_distance'],
            order['orders_organization']['max_active_orderCount'],
            order['orders_organization']['max_order_close_distance'],
            order['orders_organization']['support_chat_url']);
        OrderModel orderModel = OrderModel.fromMap(order);
        orderModel.customer.target = customer;
        orderModel.terminal.target = terminals;
        orderModel.orderStatus.target = orderStatus;
        orderModel.organization.target = organizations;
        if (order['next_buttons'] != null) {
          order['next_buttons'].forEach((button) {
            OrderNextButton orderNextButton = OrderNextButton.fromMap(button);
            orderModel.orderNextButton.add(orderNextButton);
          });
        }
        objectBox.updateCurrentOrder(widget.order.identity, orderModel);
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 5))
          ],
          color: Colors.white),
      clipBehavior: Clip.antiAlias,
      child: ExpandablePanel(
          header: Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.order.organization.target != null &&
                        widget.order.organization.target!.iconUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          height: 30,
                          imageUrl: widget.order.organization.target!.iconUrl!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : const SizedBox(width: 0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "#${widget.order.order_number}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(widget.order.created_at),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          collapsed: Column(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.customer_name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.order.customer.target!.name),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.customer_phone,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.order.customer.target!.phone),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(
                          widget.order.terminal.target!.name,
                          maxLines: 4,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(Uri.parse(
                                      "yandexnavi://build_route_on_map?lat_to=${widget.order.from_lat}&lon_to=${widget.order.from_lon}"));
                                },
                                child: Icon(
                                  Icons.navigation_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_control_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(Uri.parse(
                                      "yandexnavi://build_route_on_map?lat_to=${widget.order.to_lat}&lon_to=${widget.order.to_lon}"));
                                },
                                child: Icon(
                                  Icons.location_pin,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            widget.order.delivery_address ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.order_total_price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          CurrencyFormatter.format(
                              widget.order.order_price, euroSettings),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.delivery_price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          CurrencyFormatter.format(
                              widget.order.delivery_price, euroSettings),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.payment_type,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          widget.order.paymentType?.toUpperCase() ?? '',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final coords =
                        Coords(widget.order.to_lat, widget.order.to_lon);
                    await launchUrl(Uri.parse(
                        "yandexnavi://build_route_on_map?lat_to=${widget.order.to_lat}&lon_to=${widget.order.to_lon}"));
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.deepPurple,
                    size: 40,
                  ),
                ),
              ],
            ),
            Container(
              color: Theme.of(context).primaryColor,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).pushNamed(
                            '/order/customer-comments/${widget.order.customer.target!.identity}/${widget.order.identity}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .order_card_comments
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 1,
                    ),
                    GestureDetector(
                      onTap: () {
                        showBarModalBottomSheet(
                          context: context,
                          expand: false,
                          builder: (context) => ApiGraphqlProvider(
                            child: OrderItemsTable(
                              orderId: widget.order.identity,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .order_card_items
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(32.0),
                    // ),
                  ),
                  onPressed: () async {
                    if (loading) return;
                    _approveOrder(widget.order.identity);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                        AppLocalizations.of(context)!.order_card_btn_accept),
                  ),
                ))
              ],
            )
          ]),
          expanded: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.customer_name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.order.customer.target!.name),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.customer_phone,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.order.customer.target!.phone),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.address,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              widget.order.delivery_address ?? '',
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       AppLocalizations.of(context)!.customer_phone,
                      //       style: const TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         FlutterPhoneDirectCaller.callNumber(
                      //             widget.order.customer.target!.phone);
                      //       },
                      //       child: Text(widget.order.customer.target!.phone),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pre_distance_label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${(widget.order.pre_distance).toString()} км"),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        widget.order.terminal.target!.name,
                        maxLines: 4,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    "yandexnavi://build_route_on_map?lat_to=${widget.order.from_lat}&lon_to=${widget.order.from_lon}"));
                              },
                              child: Icon(
                                Icons.navigation_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_control_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            GestureDetector(
                              onTap: () async {
                                print(
                                    "yandexnavi://build_route_on_map?lat_to=${widget.order.to_lat}&lon_to=${widget.order.to_lon}");
                                await launchUrl(Uri.parse(
                                    "yandexnavi://build_route_on_map?lat_to=${widget.order.to_lat}&lon_to=${widget.order.to_lon}"));
                              },
                              child: Icon(
                                Icons.location_pin,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                          child: Text(
                        widget.order.delivery_address ?? '',
                        maxLines: 4,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.order_total_price,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                widget.order.order_price, euroSettings),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.delivery_price,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                widget.order.delivery_price, euroSettings),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.order_status_label,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            widget.order.orderStatus.target!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.payment_type,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            widget.order.paymentType?.toUpperCase() ?? '',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final coords =
                              Coords(widget.order.to_lat, widget.order.to_lon);
                          final title = widget.order.delivery_address ?? '';
                          final availableMaps = await MapLauncher.installedMaps;
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: Wrap(
                                      children: <Widget>[
                                        for (var map in availableMaps)
                                          ListTile(
                                            onTap: () => map.showMarker(
                                              coords: coords,
                                              title: title,
                                            ),
                                            title: Text(map.mapName),
                                            leading: SvgPicture.asset(
                                              map.icon,
                                              height: 30.0,
                                              width: 30.0,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                      ),
                    ],
                  )),
              Container(
                color: Theme.of(context).primaryColor,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).pushNamed(
                              '/order/customer-comments/${widget.order.customer.target!.identity}/${widget.order.identity}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .order_card_comments
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                        width: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          showBarModalBottomSheet(
                            context: context,
                            expand: false,
                            builder: (context) => ApiGraphqlProvider(
                              child: OrderItemsTable(
                                orderId: widget.order.identity,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .order_card_items
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(32.0),
                      // ),
                    ),
                    onPressed: () async {
                      if (loading) return;
                      _approveOrder(widget.order.identity);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                          AppLocalizations.of(context)!.order_card_btn_accept),
                    ),
                  ))
                ],
              )
            ],
          )),
    );
  }
}
