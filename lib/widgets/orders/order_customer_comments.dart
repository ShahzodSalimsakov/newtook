import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';
import 'package:newtook/models/customer_comments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderCustomerCommentsPage extends StatelessWidget {
  const OrderCustomerCommentsPage(
      {super.key, @PathParam('customerId') required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(
        child: OrderCustomerCommentsView(customerId: customerId));
  }
}

class OrderCustomerCommentsView extends StatefulWidget {
  const OrderCustomerCommentsView({super.key, required this.customerId});
  final String customerId;

  @override
  State<OrderCustomerCommentsView> createState() =>
      _OrderCustomerCommentsViewState();
}

class _OrderCustomerCommentsViewState extends State<OrderCustomerCommentsView> {
  bool isLoading = true;
  List<CustomerCommentsModel> comments = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _getCustomerComments() async {
    try {
      var client = GraphQLProvider.of(context).value;
      var query = gql('''
      query {
        customerComments(customerId: "${widget.customerId}") {
          id
          comment
          customer_id
          created_at
        }
      }
    ''');
      QueryResult result = await client.query(QueryOptions(
          document: query,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        AnimatedSnackBar.material(
          result.exception?.graphqlErrors[0].message ?? "Error",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }

      if (result.data != null) {
        print('''
      query {
        customerComments(customerId: "${widget.customerId}") {
          id
          comment
          created_at
        }
      }
    ''');
        print(result);
        setState(() {
          comments = (result.data!['customerComments'] as List)
              .map((e) => CustomerCommentsModel.fromMap(e))
              .toList();
        });
      }

      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      AnimatedSnackBar.material(
        e.message ?? "Error",
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveCustomerComment() async {
    var comment = _controller.text;
    try {
      var client = GraphQLProvider.of(context).value;
      var query = gql('''
      mutation {
        createCustomerComment(customerId: "${widget.customerId}", comment: "$comment") {
          id
          comment
          customer_id
          created_at
        }
      }
    ''');
      QueryResult result = await client.mutate(MutationOptions(
          document: query,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        AnimatedSnackBar.material(
          result.exception?.graphqlErrors[0].message ?? "Error",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }

      if (result.data != null) {
        _controller.text = "";
        setState(() {
          comments.add(CustomerCommentsModel.fromMap(
              result.data!['createCustomerComment']));
        });
      }

      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      AnimatedSnackBar.material(
        e.message ?? "Error",
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCustomerComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.order_card_comments),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (comments.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.order_card_comments),
        ),
        body: const Center(
          child: Text("No comments"),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.order_card_comments),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 70,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return BubbleSpecialThree(
                          text: comments[index].comment,
                          isSender: true,
                          color: Theme.of(context).primaryColor,
                          tail: true,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    margin: EdgeInsets.only(bottom: keyboardOpen ? 0 : 10),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: AppLocalizations.of(context)!
                                .customer_orders_type_comment,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (value) {
                            saveCustomerComment();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        onPressed: () {
                          saveCustomerComment();
                        },
                      )
                    ]),
                  )
                  // Positioned(
                  //     child: ,
                  //     bottom: keyboardOpen ? 150 : 30,
                  //     left: 0,
                  //     right: 0)
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
