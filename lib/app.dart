import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newtook/bloc/block_imports.dart';
import 'package:newtook/bloc/user_data/user_data_bloc.dart';
import 'package:newtook/l10n/support_locale.dart';
import 'package:newtook/provider/locale_provider.dart';
import 'package:newtook/router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApiClientsBloc>(
          create: (context) => ApiClientsBloc(),
        ),
        BlocProvider<OtpPhoneNumberBloc>(
          create: (context) => OtpPhoneNumberBloc(),
        ),
        BlocProvider<OtpTokenBloc>(
          create: (context) => OtpTokenBloc(),
        ),
        BlocProvider<UserDataBloc>(create: (context) => UserDataBloc())
      ],
      child: BlocConsumer<UserDataBloc, UserDataState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return ChangeNotifierProvider(
              create: (context) => LocaleProvider(),
              builder: (context, child) {
                return Consumer<LocaleProvider>(
                    builder: (context, provider, child) {
                  return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: L10n.support,
                      locale: provider.locale,
                      theme: ThemeData(
                          backgroundColor: Colors.white,
                          primarySwatch: Colors.deepPurple,
                          primaryColor: Colors.deepPurple.shade400,
                          fontFamily: GoogleFonts.nunito().fontFamily,
                          textTheme: TextTheme(
                            headline1: GoogleFonts.nunito(
                                fontSize: 97,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1.5),
                            headline2: GoogleFonts.nunito(
                                fontSize: 61,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.5),
                            headline3: GoogleFonts.nunito(
                                fontSize: 48, fontWeight: FontWeight.w400),
                            headline4: GoogleFonts.nunito(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.25),
                            headline5: GoogleFonts.nunito(
                                fontSize: 24, fontWeight: FontWeight.w400),
                            headline6: GoogleFonts.nunito(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.15),
                            subtitle1: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15),
                            subtitle2: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1),
                            bodyText1: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5),
                            bodyText2: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25),
                            button: GoogleFonts.nunito(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.25,
                                color: Colors.white),
                            caption: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4),
                            overline: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5),
                          )),
                      routerDelegate: _rootRouter.delegate(
                        navigatorObservers: () => [AutoRouteObserver()],
                      ),
                      // routeInformationProvider: _rootRouter.routeInfoProvider(),
                      routeInformationParser: _rootRouter.defaultRouteParser());
                });
              });
        },
      ),
    );
  }
}
