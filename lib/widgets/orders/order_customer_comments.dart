import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:arryt/models/customer_comments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../bloc/block_imports.dart';

class OrderCustomerCommentsPage extends StatelessWidget {
  const OrderCustomerCommentsPage(
      {super.key,
      @PathParam('customerId') required this.customerId,
      @PathParam('orderId') required this.orderId});
  final String customerId;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(
        child: OrderCustomerCommentsView(
      customerId: customerId,
      orderId: orderId,
    ));
  }
}

class OrderCustomerCommentsView extends StatefulWidget {
  const OrderCustomerCommentsView(
      {super.key, required this.customerId, required this.orderId});
  final String customerId;
  final String orderId;

  @override
  State<OrderCustomerCommentsView> createState() =>
      _OrderCustomerCommentsViewState();
}

class _OrderCustomerCommentsViewState extends State<OrderCustomerCommentsView> {
  bool isLoading = true;
  List<CustomerCommentsModel> comments = [];
  List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _getCustomerComments() async {
    try {
      var client = GraphQLProvider.of(context).value;
      var query = gql('''
      query {
        customerComments(customerId: "${widget.customerId}", orderId: "${widget.orderId}") {
          id
          comment
          customer_id
          created_at
          customers_comments_voice_idToassets {
            id
            model
            file_name
            sub_folder
          }
          customers_comments_image_idToassets {
            id
            model
            file_name
            sub_folder
          }
        }
      }
    ''');
      QueryResult result = await client.query(QueryOptions(
          document: query,
          // cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          fetchPolicy: FetchPolicy.noCache));
      if (result.hasException) {
        AnimatedSnackBar.material(
          result.exception?.graphqlErrors[0].message ?? "Error",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }

      if (result.data != null) {
        ApiClientsState apiClientsState =
            BlocProvider.of<ApiClientsBloc>(context).state;
        final apiClient = apiClientsState.apiClients.firstWhere(
            (element) => element.isServiceDefault == true,
            orElse: () => apiClientsState.apiClients.first);
        List<ChatMessage> resMessages =
            (result.data!['customerComments'] as List)
                .map((e) => CustomerCommentsModel.fromMap(e))
                .map(
          (e) {
            if (e.customers_comments_image_idToassets != null) {
              FileAsset imageData = e.customers_comments_image_idToassets!;
              return ChatMessage(
                  isSender: true,
                  imageUrl:
                      "https://${apiClient.apiUrl}/${imageData.model}/${imageData.sub_folder}/${imageData.file_name}",
                  createdAt: e.created_at);
            }
            if (e.customers_comments_voice_idToassets != null) {
              FileAsset voiceData = e.customers_comments_voice_idToassets!;
              return ChatMessage(
                  isSender: true,
                  audioUrl:
                      "https://${apiClient.apiUrl}/${voiceData.model}/${voiceData.sub_folder}/${voiceData.file_name}",
                  createdAt: e.created_at);
            }
            return ChatMessage(
                isSender: true, text: e.comment, createdAt: e.created_at);
          },
        ).toList();
        setState(() {
          comments = (result.data!['customerComments'] as List)
              .map((e) => CustomerCommentsModel.fromMap(e))
              .toList();
          messages = resMessages;
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
          customers_comments_voice_idToassets {
            id
            model
            file_name
            sub_folder
          }
          customers_comments_image_idToassets {
            id
            model
            file_name
            sub_folder
          }
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

  Widget addCommentWidget() {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      color: Colors.grey.shade200,
      margin: EdgeInsets.only(bottom: keyboardOpen ? 0 : 10),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
              hintText:
                  AppLocalizations.of(context)!.customer_orders_type_comment,
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
    );
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
        body: ChatScreen(
          messages: messages,
          sendMessageHintText:
              AppLocalizations.of(context)!.commentFieldLabel.toUpperCase(),
          senderColor: Theme.of(context).primaryColor,
          imageAttachmentFromGalary: AppLocalizations.of(context)!
              .chooseImageFromGallery
              .toUpperCase(),
          imageAttachmentFromCamery:
              AppLocalizations.of(context)!.chooseImageFromCamery.toUpperCase(),
          imageAttachmentCancelText: AppLocalizations.of(context)!
              .imageAttachmentCancelText
              .toUpperCase(),
          handleImageSelect: (p0) async {
            const uploadImage = r"""
                mutation uploadCustomerImageComment($file: Upload!, $customerId: String!) {
                  uploadCustomerImageComment(customerId: $customerId, file: $file) {
                    id
                  }
                }
                """;
            var bytes = p0.readAsBytes();
            var multipartFile = MultipartFile.fromBytes(
                'file', await bytes,
                filename: p0.name);
            var opts = MutationOptions(
              document: gql(uploadImage),
              variables: {
                "file": multipartFile,
                "customerId": widget.customerId
              },
            );
            var client = GraphQLProvider.of(context).value;

            var results = await client.mutate(opts);

            _getCustomerComments();
          },
          handleRecord: (path, canceled) async {
            if (!canceled) {
              const uploadImage = r"""
                mutation uploadCustomerVoiceComment($file: Upload!, $customerId: String!) {
                  uploadCustomerVoiceComment(customerId: $customerId, file: $file) {
                    id
                  }
                }
                """;
              var multipartFile = await MultipartFile.fromPath('file', path!,
                  contentType: MediaType("audio", "m4a"));
              var opts = MutationOptions(
                document: gql(uploadImage),
                variables: {
                  "file": multipartFile,
                  "customerId": widget.customerId
                },
              );
              var client = GraphQLProvider.of(context).value;

              var results = await client.mutate(opts);

              _getCustomerComments();
            }
          },
        ),
      );
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.order_card_comments),
          ),
          body: ChatScreen(
            messages: messages,
            sendMessageHintText:
                AppLocalizations.of(context)!.commentFieldLabel.toUpperCase(),
            senderColor: Theme.of(context).primaryColor,
            imageAttachmentFromGalary: AppLocalizations.of(context)!
                .chooseImageFromGallery
                .toUpperCase(),
            imageAttachmentFromCamery: AppLocalizations.of(context)!
                .chooseImageFromCamery
                .toUpperCase(),
            imageAttachmentCancelText: AppLocalizations.of(context)!
                .imageAttachmentCancelText
                .toUpperCase(),
            handleImageSelect: (p0) async {
              const uploadImage = r"""
                mutation uploadCustomerImageComment($file: Upload!, $customerId: String!) {
                  uploadCustomerImageComment(customerId: $customerId, file: $file) {
                    id
                  }
                }
                """;
              var bytes = p0.readAsBytes();
              var multipartFile = MultipartFile.fromBytes(
                  'file', await bytes,
                  filename: p0.name);
              var opts = MutationOptions(
                document: gql(uploadImage),
                variables: {
                  "file": multipartFile,
                  "customerId": widget.customerId
                },
              );
              var client = GraphQLProvider.of(context).value;

              var results = await client.mutate(opts);

              _getCustomerComments();
            },
            handleRecord: (path, canceled) async {
              if (!canceled) {
                const uploadImage = r"""
                mutation uploadCustomerVoiceComment($file: Upload!, $customerId: String!) {
                  uploadCustomerVoiceComment(customerId: $customerId, file: $file) {
                    id
                  }
                }
                """;
                var multipartFile = await MultipartFile.fromPath('file', path!,
                    contentType: MediaType("audio", "m4a"));
                var opts = MutationOptions(
                  document: gql(uploadImage),
                  variables: {
                    "file": multipartFile,
                    "customerId": widget.customerId
                  },
                );
                var client = GraphQLProvider.of(context).value;

                var results = await client.mutate(opts);

                _getCustomerComments();
              }
            },
          ));
    }
  }
}
