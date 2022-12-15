import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:arryt/models/couriers.dart';
import 'package:arryt/models/order.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderChangeCourier extends StatelessWidget {
  OrderModel order;
  OrderChangeCourier({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(child: OrderChangeCourierView(order: order));
  }
}

class OrderChangeCourierView extends StatefulWidget {
  OrderModel order;
  OrderChangeCourierView({super.key, required this.order});

  @override
  State<OrderChangeCourierView> createState() => _OrderChangeCourierViewState();
}

class _OrderChangeCourierViewState extends State<OrderChangeCourierView> {
  List<Couriers> couriers = [];

  Future<void> _loadCouriers() async {
    var client = GraphQLProvider.of(context).value;
    var query = r'''
      query {
        myCouriers {
          id
          first_name
          last_name
        }
      }
    ''';
    var result = await client.query(QueryOptions(
        document: gql(query), fetchPolicy: FetchPolicy.cacheAndNetwork));
    if (result.hasException) {
      print(result.exception);
      return;
    }
    var data = result.data!['myCouriers'] as List;
    setState(() {
      couriers = data.map((e) => Couriers.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCouriers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
              AppLocalizations.of(context)!.chooseCourierLabel.toUpperCase()),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: couriers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(couriers[index].firstName +
                          ' ' +
                          couriers[index].lastName),
                      onTap: () {
                        Navigator.pop(context, couriers[index]);
                      });
                }))
      ],
    );
  }
}
