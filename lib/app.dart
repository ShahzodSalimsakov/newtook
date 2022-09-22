import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newtook/router.dart';
import 'package:newtook/splash/view/splash_page.dart';
import 'package:user_repository/user_repository.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'login/view/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _rootRouter = AppRouter(
      // authGuard: AuthGuard(),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('ru', ''),
          Locale('uz', ''),
        ],
        routerDelegate: _rootRouter.delegate(
          navigatorObservers: () => [AutoRouteObserver()],
        ),
        // routeInformationProvider: _rootRouter.routeInfoProvider(),
        routeInformationParser: _rootRouter.defaultRouteParser());
  }
}
