import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WithdrawForCourier extends StatelessWidget {
  final String courierId;
  final String terminalId;
  final int balance;
  final Function refresh;
  const WithdrawForCourier(
      {super.key,
      required this.courierId,
      required this.terminalId,
      required this.balance,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ApiGraphqlProvider(
        child: WithdrawForCourierView(
      balance: balance,
      courierId: courierId,
      terminalId: terminalId,
      refresh: refresh,
    ));
  }
}

class WithdrawForCourierView extends StatefulWidget {
  final String courierId;
  final String terminalId;
  final int balance;
  final Function refresh;
  const WithdrawForCourierView(
      {super.key,
      required this.courierId,
      required this.terminalId,
      required this.balance,
      required this.refresh});

  @override
  State<WithdrawForCourierView> createState() => _WithdrawForCourierViewState();
}

class _WithdrawForCourierViewState extends State<WithdrawForCourierView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  CurrencyFormatterSettings euroSettings = CurrencyFormatterSettings(
    symbol: 'сум',
    symbolSide: SymbolSide.right,
    thousandSeparator: ' ',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            )),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
                AppLocalizations.of(context)!.currentBalanceLabel.toUpperCase(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Text(CurrencyFormatter.format(widget.balance, euroSettings),
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: AppLocalizations.of(context)!.typeWithdrawAmount,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _amountController.text.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: const Size.fromHeight(55)),
                  onPressed: () {
                    if (_amountController.text.isNotEmpty) {
                      var client = GraphQLProvider.of(context).value;
                      var query = r'''
                mutation withdrawCourierBalance($amount: Int!, $courier_id: String!, $terminal_id: String!) {
                  withdrawCourierBalance(amount: $amount, courier_id: $courier_id, terminal_id: $terminal_id) {
                    id
                  }
                }
              ''';
                      client.mutate(MutationOptions(
                          document: gql(query),
                          variables: {
                            'amount': int.parse(_amountController.text),
                            'courier_id': widget.courierId,
                            'terminal_id': widget.terminalId
                          },
                          onCompleted: (dynamic resultData) {
                            widget.refresh();
                            Navigator.pop(context);
                          }));
                    }
                  },
                  child:
                      Text(AppLocalizations.of(context)!.withdrawButtonLabel)),
            ),
          ],
        ));
  }
}
