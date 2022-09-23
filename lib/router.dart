import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:newtook/pages/home/view/home_page.dart';
import 'package:newtook/pages/initial.dart';
import 'package:newtook/pages/login/type_otp.dart';
import 'package:newtook/pages/login/type_phone.dart';
import 'package:newtook/pages/qr/qr.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: InitialPage, initial: true),
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: QRPage, path: '/qr'),
    AutoRoute(page: LoginTypePhonePage, path: '/login/type-phone'),
    AutoRoute(page: LoginTypeOtpPage, path: '/login/type-otp'),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}
