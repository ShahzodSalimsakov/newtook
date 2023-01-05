import 'dart:convert';

import 'package:arryt/models/brands.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

import '../../bloc/block_imports.dart';

class ApiClientChooseBrand extends StatefulWidget {
  const ApiClientChooseBrand({super.key});

  @override
  State<ApiClientChooseBrand> createState() => _ApiClientChooseBrandState();
}

class _ApiClientChooseBrandState extends State<ApiClientChooseBrand> {
  List<BrandsModel> _brands = [];
  bool isLoading = false;

  Future<void> _loadBrands() async {
    setState(() {
      isLoading = true;
    });
    // create http graphql request to get brands
    // save brands to _brands
    var query = r'''
      query {
        brands {
          id
          name
          logo_path
          sign
        }
      }
    ''';
    var response = await http.post(
      Uri.parse('https://api.arryt.uz/graphql'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(<String, String>{'query': query}),
    );
    var data = json.decode(response.body) as Map<String, dynamic>;
    var brands = data['data']['brands'] as List<dynamic>;
    setState(() {
      isLoading = false;
      _brands = brands
          .map((e) => BrandsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> selectBrand(BrandsModel brand) async {
    setState(() {
      isLoading = true;
    });
    String hexString = brand.sign;
    List<String> splitted = [];
    for (int i = 0; i < hexString.length; i = i + 2) {
      splitted.add(hexString.substring(i, i + 2));
    }
    String ascii = List.generate(splitted.length,
        (i) => String.fromCharCode(int.parse(splitted[i], radix: 16))).join();

    // remove first 6 characters from ascii
    String asciiWithoutFirst6 = ascii.substring(6);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // base64 decode
    String base64Decoded = stringToBase64.decode(asciiWithoutFirst6);
    String apiUrl = base64Decoded.split("|")[0];
    String serviceName = base64Decoded.split("|")[1];
    try {
      var response = await http.post(
        Uri.parse('https://$apiUrl/graphql'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '''
        {
          "query": "query {checkService {\\n result}}\\n",
          "variables": null
        }
        ''',
      );
      var result = jsonDecode(response.body);
      if (result['errors'] != null) {
        _onErrorServiceCheck(context);
      } else {
        _onSuccessServiceCheck(context, serviceName, apiUrl);
      }
    } catch (e) {
      print(e);
      _onErrorServiceCheck(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBrands();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: LoadingOverlay(
          isLoading: isLoading,
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AutoSizeText('Выберите\n бренд'.toUpperCase(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _brands.length,
                  itemBuilder: (context, index) {
                    var brand = _brands[index];
                    return GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20.0,
                            bottom: 45 + bottom,
                            right: 20,
                            left: 20),
                        child: Card3DWidget(card: brand),
                      ),
                      onTap: () => selectBrand(brand),
                    );
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }

  void _onErrorServiceCheck(BuildContext context) {
    setState(() {
      isLoading = false;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.error_label,
            ),
            content:
                Text(AppLocalizations.of(context)!.this_service_is_not_valid),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  Future<void> _onSuccessServiceCheck(
      BuildContext context, String serviceName, String apiUrl) async {
    setState(() {
      isLoading = false;
    });
    BlocProvider.of<ApiClientsBloc>(context).add(ApiClientsAdd(
        apiUrl: apiUrl, serviceName: serviceName, isServiceDefault: true));
    // context.read<ApiClientsBloc>().add(ApiClientsAdd(
    //     apiUrl: apiUrl, serviceName: serviceName, isServiceDefault: true));
    await Future.delayed(Duration.zero);
    AutoRouter.of(context).replaceNamed('/login/type-phone');
  }
}

class Card3DWidget extends StatelessWidget {
  const Card3DWidget({Key? key, this.card}) : super(key: key);

  final BrandsModel? card;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15.0);
    return PhysicalModel(
      color: Colors.white,
      elevation: 10,
      borderRadius: border,
      child: ClipRRect(
        borderRadius: border,
        child: Image.network(
          card!.logoPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
