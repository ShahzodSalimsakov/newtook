import 'dart:async';
import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:load_switch/load_switch.dart';
import 'package:arryt/bloc/block_imports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/location_dialog.dart';

class HomeViewWorkSwitch extends StatefulWidget {
  const HomeViewWorkSwitch({super.key});

  @override
  State<HomeViewWorkSwitch> createState() => _HomeViewWorkSwitchState();
}

class _HomeViewWorkSwitchState extends State<HomeViewWorkSwitch> {
  StreamSubscription<Position>? positionStream;
  bool value = false;

  Future<bool> _toggleWork(BuildContext context) async {
    UserDataBloc userDataBloc = BlocProvider.of<UserDataBloc>(context);
    var client = GraphQLProvider.of(context).value;
    UserDataState userDataState = context.read<UserDataBloc>().state;

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await showLocationDialog(context);
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await Geolocator.requestPermission();
        return userDataState.is_online;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return userDataState.is_online;
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    print('get current position');
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
        positionStream?.cancel();
        setState(() {
          positionStream = null;
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
        final LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        );

        positionStream =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((Position? position) async {
          var query = gql('''mutation {
            storeLocation(latitude: ${position!.latitude}, longitude: ${position!.longitude}) {
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
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await showLocationDialog(context);
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        await Geolocator.openLocationSettings();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          await Geolocator.requestPermission();
        }
      }

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      );
      try {
        positionStream =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((Position? currentLocation) async {
          var accessToken = userDataState.refreshToken;
          ApiClientsState apiClientsState =
              BlocProvider.of<ApiClientsBloc>(context).state;
          final apiClient = apiClientsState.apiClients.firstWhere(
              (element) => element.isServiceDefault == true,
              orElse: () => apiClientsState.apiClients.first);
          if (DateTime.now().isAfter(userDataState.tokenExpires)) {
            if (apiClient != null) {
              try {
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
                                  hours: int.parse(data!['accessTokenExpires']
                                      .split('h')[0]))),
                            ),
                          );
                    });
                  }
                }
              } catch (e) {
                print(e);
              }
            }
          }

          try {
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
          } catch (e) {
            print(e);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationListen();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    positionStream?.cancel();
    super.dispose();
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
