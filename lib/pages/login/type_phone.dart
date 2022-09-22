import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/bloc/otp_phone_number/otp_phone_number_bloc.dart';
import 'package:newtook/helpers/api_graphql_provider.dart';

import '../../widgets/wave/wave_widget.dart';

class LoginTypePhonePage extends StatefulWidget {
  LoginTypePhonePage({Key? key}) : super(key: key);

  @override
  State<LoginTypePhonePage> createState() => _LoginTypePhonePageState();
}

class _LoginTypePhonePageState extends State<LoginTypePhonePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String initialCountry = 'UZ';

  PhoneNumber number = PhoneNumber(isoCode: 'UZ');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: size.height - 200,
            color: Theme.of(context).primaryColor,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 2.5,
              color: Colors.white,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        showFlags: false,
                        setSelectorButtonAsPrefixIcon: true,
                        leadingPadding: 0),
                    errorMessage:
                        AppLocalizations.of(context)!.typed_phone_incorrect,
                    inputDecoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.phone_field_label,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    // hintText: AppLocalizations.of(context)!.phone_field_label,
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40)),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                    countries: ['UZ'],
                    countrySelectorScrollControlled: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    // child: ApiGraphqlProvider(
                    child: GestureDetector(
                      onTap: () {
                        print("object");
                        print(controller.text);
                        // print(context
                        //     .select((ApiClientsBloc value) => value.state));
                        print(context.read<ApiClientsBloc>().state);
                        // context.read<OtpPhoneNumberBloc>().add(
                        //     OtpPhoneNumberChanged(
                        //         phoneNumber: controller.text));
                        ApiClientsBloc apiClientsBloc =
                            BlocProvider.of<ApiClientsBloc>(context);
                        print(apiClientsBloc.state.apiClients);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .send_code
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
