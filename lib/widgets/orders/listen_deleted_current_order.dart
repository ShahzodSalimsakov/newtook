import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/main.dart';

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
      if (result.data != null && result.data!['deletedCurrentOrder'] != null) {
        objectBox.deleteCurrentOrder(
          result.data!['deletedCurrentOrder']['id'],
        );
      }
    }

    useEffect(() {}, []);

    return const SizedBox();
  }
}
