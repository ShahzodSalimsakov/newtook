import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final subscriptionDocument = gql(
  r'''
    subscription deletedCurrentOrder {
      deletedCurrentOrder {
        id
      }
    }
  ''',
);

class ListenDeletedCurrentOrders extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final result = useSubscription(
      SubscriptionOptions(
        document: subscriptionDocument,
      ),
    );

    if (!result.hasException && !result.isLoading) {
      print(result.data);
    }

    useEffect(() {}, []);

    return const SizedBox();
  }
}
