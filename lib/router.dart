import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:newtook/pages/home/view/home_page.dart';
import 'package:newtook/pages/initial.dart';
import 'package:newtook/pages/qr/qr.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: InitialPage, initial: true),
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: QRPage, path: '/qr'),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}
