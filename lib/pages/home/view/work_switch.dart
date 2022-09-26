import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:load_switch/load_switch.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeViewWorkSwitch extends StatefulWidget {
  const HomeViewWorkSwitch({super.key});

  @override
  State<HomeViewWorkSwitch> createState() => _HomeViewWorkSwitchState();
}

class _HomeViewWorkSwitchState extends State<HomeViewWorkSwitch> {
  bool value = false;

  Future<bool> _toggleWork(BuildContext context) async {
    print(value);
    UserDataBloc userDataBloc = BlocProvider.of<UserDataBloc>(context);
    var client = GraphQLProvider.of(context).value;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        AnimatedSnackBar.material(
          AppLocalizations.of(context)!.location_is_disabled_error,
          type: AnimatedSnackBarType.error,
        ).show(context);
        return value;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      AnimatedSnackBar.material(
        AppLocalizations.of(context)!.location_is_disabled_error,
        type: AnimatedSnackBarType.error,
      ).show(context);
      return value;
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
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
        return true;
      }
    }
    return !value;
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
