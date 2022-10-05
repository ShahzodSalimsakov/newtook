import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          return const SizedBox();
        }
      } else {
        return Text(AppLocalizations.of(context)!.you_are_not_courier,
            style: Theme.of(context).textTheme.headline6);
      }
    });
  }
}
