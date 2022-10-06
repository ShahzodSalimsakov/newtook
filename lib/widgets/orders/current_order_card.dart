import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:newtook/models/order.dart';

class CurrentOrderCard extends StatelessWidget {
  final OrderModel order;
  const CurrentOrderCard({super.key, required this.order});

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
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  order.orderStatus.target!.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
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
      ]),
    );
  }
}
