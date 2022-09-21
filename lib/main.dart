import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/user_repository.dart';

import 'app.dart';

// Future<void> main() async {
//   runApp(
//     App(
//       authenticationRepository: AuthenticationRepository(),
//       userRepository: UserRepository(),
//     ),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  await initHiveForFlutter();

  HydratedBlocOverrides.runZoned(
      () => {
            runApp(
              App(),
            )
          },
      storage: storage);
}
