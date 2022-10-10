import 'package:auto_route/auto_route.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:newtook/models/order.dart';
import 'package:newtook/widgets/orders/orders_items.dart';

import 'order_customer_comments.dart';

class CurrentOrderCard extends StatelessWidget {
  final OrderModel order;
  CurrentOrderCard({super.key, required this.order});

  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
    symbol: 'сум',
    symbolSide: SymbolSide.right,
    thousandSeparator: ' ',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Column(children: [
        Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "#${order.order_number}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(order.created_at),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
                    Text(order.customer.target!.name),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order.delivery_address ?? '',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.customer_phone,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        FlutterPhoneDirectCaller.callNumber(
                            order.customer.target!.phone);
                      },
                      child: Text(order.customer.target!.phone),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pre_distance_label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${(order.pre_distance / 1000).toString()} км"),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       AppLocalizations.of(context)!.payment_type,
                //       style: const TextStyle(fontSize: 20),
                //     ),
                //     Text(
                //       order.payment_type,
                //       style: const TextStyle(fontSize: 20),
                //     ),
                //   ],
                // ),
              ],
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  order.terminal.target!.name,
                  maxLines: 4,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.navigation_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      Icon(
                        Icons.keyboard_control_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      Icon(
                        Icons.location_pin,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: Text(
                  order.delivery_address ?? '',
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
                      CurrencyFormatter.format(order.order_price, euroSettings),
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
                          order.delivery_price, euroSettings),
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
                      order.orderStatus.target!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                )
              ],
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final coords = Coords(order.to_lat, order.to_lon);
                    final title = order.delivery_address ?? '';
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
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    String number =
                        order.customer.target!.phone; //set the number here
                    bool? res =
                        await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  child: const Icon(
                    Icons.phone_in_talk_outlined,
                    color: Colors.green,
                    size: 40,
                  ),
                )
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
                        '/order/customer-comments/${order.customer.target!.identity}');
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
                          orderId: order.identity,
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
        )
      ]),
    );
  }
}
