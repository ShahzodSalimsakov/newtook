import 'dart:async';
import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:load_switch/load_switch.dart';
import 'package:location/location.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class HomeViewWorkSwitch extends StatefulWidget {
  const HomeViewWorkSwitch({super.key});

  @override
  State<HomeViewWorkSwitch> createState() => _HomeViewWorkSwitchState();
}

class _HomeViewWorkSwitchState extends State<HomeViewWorkSwitch> {
  StreamSubscription<LocationData>? _locationSubscription;
  bool value = false;

  Location location = new Location();

  Future<bool> enableBackgroundMode() async {
    bool _bgModeEnabled = await location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        _bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(_bgModeEnabled); //True!
      return _bgModeEnabled;
    }
  }

  Future<bool> _toggleWork(BuildContext context) async {
    UserDataBloc userDataBloc = BlocProvider.of<UserDataBloc>(context);
    var client = GraphQLProvider.of(context).value;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        AnimatedSnackBar.material(
          AppLocalizations.of(context)!.location_is_disabled_error,
          type: AnimatedSnackBarType.error,
        ).show(context);
        return value;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        AnimatedSnackBar.material(
          AppLocalizations.of(context)!.location_is_disabled_error,
          type: AnimatedSnackBarType.error,
        ).show(context);
        return value;
      }
    }

    LocationData currentPosition = await location.getLocation();
    UserDataState userDataState = context.read<UserDataBloc>().state;
    if (userDataState.is_online) {
      var query = gql('''
      mutation {
        closeTimeEntry(lat_close: ${currentPosition.latitude}, lon_close: ${currentPosition.longitude}) {
          id
        }
      }
    ''');

      QueryResult result =
          await client.mutate(MutationOptions(document: query));
      if (result.hasException) {
        AnimatedSnackBar.material(
          result.exception?.graphqlErrors[0].message ?? "Error",
          type: AnimatedSnackBarType.error,
        ).show(context);
        return value;
      }

      if (result.data!['closeTimeEntry']['id'] != null) {
        context.read<UserDataBloc>().add(UserDataEventChange(
              accessToken: userDataBloc.state.accessToken,
              is_online: false,
              accessTokenExpires: userDataBloc.state.accessTokenExpires,
              refreshToken: userDataBloc.state.refreshToken,
              permissions: userDataBloc.state.permissions,
              roles: userDataBloc.state.roles,
              userProfile: userDataBloc.state.userProfile,
              tokenExpires: userDataBloc.state.tokenExpires,
            ));
        _locationSubscription?.cancel();
        setState(() {
          _locationSubscription = null;
        });
        return false;
      }
    } else {
      var query = gql('''
      mutation {
        openTimeEntry(lat_open: ${currentPosition.latitude}, lon_open: ${currentPosition.longitude}) {
          id
        }
      }
    ''');
      QueryResult result =
          await client.mutate(MutationOptions(document: query));

      if (result.hasException) {
        AnimatedSnackBar.material(
          result.exception?.graphqlErrors[0].message ?? "Error",
          type: AnimatedSnackBarType.error,
        ).show(context);
        return value;
      }

      if (result.data!['openTimeEntry']['id'] != null) {
        ApiClientsState apiClientsState =
            BlocProvider.of<ApiClientsBloc>(context).state;
        final apiClient = apiClientsState.apiClients.firstWhere(
            (element) => element.isServiceDefault == true,
            orElse: () => apiClientsState.apiClients.first);
        context.read<UserDataBloc>().add(UserDataEventChange(
              accessToken: userDataBloc.state.accessToken,
              is_online: true,
              accessTokenExpires: userDataBloc.state.accessTokenExpires,
              refreshToken: userDataBloc.state.refreshToken,
              permissions: userDataBloc.state.permissions,
              roles: userDataBloc.state.roles,
              userProfile: userDataBloc.state.userProfile,
              tokenExpires: userDataBloc.state.tokenExpires,
            ));
        enableBackgroundMode();
        location.changeSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 2,
            interval: 30000);
        _locationSubscription = location.onLocationChanged
            .listen((LocationData currentLocation) async {
          var query = gql('''mutation {
            storeLocation(latitude: ${currentLocation!.latitude}, longitude: ${currentLocation!.longitude}) {
              success
              }
              },''');
          QueryResult result =
              await client.mutate(MutationOptions(document: query));
        });

        return true;
      }
    }
    return !value;
  }

  Future<void> checkLocationListen() async {
    UserDataState userDataState = context.read<UserDataBloc>().state;
    if (userDataState.is_online) {
      enableBackgroundMode();
      location.changeSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 2, interval: 30000);
      _locationSubscription = location.onLocationChanged
          .listen((LocationData currentLocation) async {
        var accessToken = userDataState.refreshToken;
        ApiClientsState apiClientsState =
            BlocProvider.of<ApiClientsBloc>(context).state;
        final apiClient = apiClientsState.apiClients.firstWhere(
            (element) => element.isServiceDefault == true,
            orElse: () => apiClientsState.apiClients.first);
        if (DateTime.now().isAfter(userDataState.tokenExpires)) {
          if (apiClient != null) {
            var requestBody = '''
        {
          "query": "mutation {refreshToken(refreshToken: \\"${userDataState.refreshToken}\\") {\\naccessToken\\naccessTokenExpires\\nrefreshToken\\n}}\\n",
          "variables": null
        }
        ''';

            var response = await http.post(
              Uri.parse("https://${apiClient.apiUrl}/graphql"),
              headers: {'Content-Type': 'application/json'},
              body: requestBody,
            );
            if (response.statusCode == 200) {
              var result = jsonDecode(response.body);
              if (result['errors'] == null) {
                var data = result['data']['refreshToken'];

                accessToken = data!['accessToken'];
                Future.delayed(Duration(microseconds: 500), () {
                  context.read<UserDataBloc>().add(
                        UserDataEventChange(
                          accessToken: data!['accessToken'],
                          accessTokenExpires: data!['accessTokenExpires'],
                          refreshToken: data!['refreshToken'],
                          permissions: userDataState.permissions,
                          roles: userDataState.roles,
                          userProfile: userDataState.userProfile,
                          is_online: userDataState.is_online,
                          tokenExpires: DateTime.now().add(Duration(
                              hours: int.parse(
                                  data!['accessTokenExpires'].split('h')[0]))),
                        ),
                      );
                });
              }
            }
          }
        }

        var requestBody = '''
        {
          "query": "mutation {storeLocation(latitude: ${currentLocation!.latitude}, longitude: ${currentLocation!.longitude}) {\\nsuccess\\n}}\\n",
          "variables": null
        }
        ''';
        var response = await http.post(
          Uri.parse("https://${apiClient.apiUrl}/graphql"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${accessToken}'
          },
          body: requestBody,
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationListen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        return Container(
          child: LoadSwitch(
            value: state.is_online,
            future: () async {
              return await _toggleWork(context);
            },
            onChange: (v) {
              value = v;
              setState(() {});
            },
            onTap: (bool) {},
          ),
        );
      },
    );
  }
}
